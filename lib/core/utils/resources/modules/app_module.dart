import 'package:meiyou/core/database/database.dart';
import 'package:meiyou/core/utils/resources/folder_provider/database_folder_provider.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/domain/source/source_manager.dart';
import 'package:meiyou/presentation/common/notifers/theme_notifer.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou_extensions_lib/extensions_lib.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:meiyou/core/config/routes/router_provider.dart';

import 'package:nice_dart/nice_dart.dart';

class AppModule extends GetItModule {
  @override
  Future<void> register() async {
    getIt.registerSingleton(ThemeNotifer());

    getIt.registerSingleton(RouterProvider());

    await DataBaseFolderProvider().path().then((path) {
      getIt.registerLazySingleton(() => DataBase(path));
    });

    getIt.registerLazySingleton(() => NetworkHelper(getIt.get()).also((it) {
          ExtensionlibOverrides.networkHelper = it;
        }));

    getIt.registerLazySingleton<ExtensionManager>(
      () => ExtensionManager(),
    );

    getIt.registerLazySingleton<SourceManager>(
      () => SourceManager(sourcePreferences: getIt.get(), manager: getIt.get()),
    );

    getIt.registerLazySingleton(() => SelectedSource(getIt.get(), getIt.get()));
  }
}
