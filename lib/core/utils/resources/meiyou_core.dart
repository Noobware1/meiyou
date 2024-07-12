import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/modules/app_module.dart';
import 'package:meiyou/core/utils/resources/modules/domain_module.dart';
import 'package:meiyou/core/utils/resources/modules/preference_module.dart';
import 'package:meiyou_extensions_lib/extensions_lib.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

class MeiyouCore {
  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();

    MediaKit.ensureInitialized();

    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
    }

    ExtensionlibOverrides.sharedPreferencesDir =
        await getApplicationSupportDirectory().then((dir) => dir.path);

    getIt = GetIt.instance;

    PreferenceModule().register();

    await AppModule().register();

    DomainModule().register();

    debugPrint('MeiyouCore initialized');
  }

  // static void reload() {
  //   PreferenceModule().reload();

  //   AppModule().reload();

  //   debugPrint('MeiyouCore reloaded');
  // }
}
