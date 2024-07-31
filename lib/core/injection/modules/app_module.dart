import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:meiyou/core/data_base/data_base.dart';
import 'package:meiyou/core/injection/modules/injection_module.dart';
import 'package:meiyou/core/router/router.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/shared/data/data_sources/folder_providers/database_folder_provider.dart';
import 'package:meiyou/shared/data/extension/extension_manager_impl.dart';
import 'package:meiyou/shared/data/source_manager/source_manager_impl.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/domain/extension_manager/extension_manger.dart';
import 'package:meiyou_extensions_lib/extensions_lib.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _getSotragePermissionForDegugMode() async {
  if (kDebugMode && Platform.isAndroid) {
    const permission = Permission.manageExternalStorage;

    Future<bool> persistPermission() {
      return permission.isDenied.then((isDenied) {
        if (isDenied) {
          return permission.request().isDenied.then((isDenied) {
            if (isDenied) persistPermission();
            return true;
          });
        }
        return true;
      });
    }

    await persistPermission();
  }
}

class AppModule implements InjectModule {
  @override
  FutureOr<void> call(GetIt getIt) async {
    _getSotragePermissionForDegugMode();

    initLogger();

    getIt.registerSingleton(RouterProvider());

    await DataBaseFolderProvider().directory().then((directory) async {
      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }
      getIt.registerLazySingleton(
        () => DataBase.open(directory.path),
      );
    });

    getIt.registerLazySingleton(
      () => NetworkHelper(getIt()).also((it) {
        ExtensionlibOverrides.networkHelper = it;
      }),
    );

    getIt.registerLazySingleton<ExtensionManager>(
      () => ExtensionManagerImpl(
        sourcePreferences: getIt(),
        network: getIt(),
      ),
    );

    getIt.registerLazySingleton<SourceManager>(
      () => SourceManagerImpl(
        sourcePreferences: getIt(),
        manager: getIt(),
      ),
    );

    await (getIt<ExtensionManager>() as ExtensionManagerImpl).init();
  }
}
