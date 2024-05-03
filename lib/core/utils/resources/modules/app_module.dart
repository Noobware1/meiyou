import 'package:injecktor/injecktor.dart';
import 'package:meiyou/data/repositories/source_repository_impl.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou/domain/source/source_manager.dart';
import 'package:meiyou_extensions_lib/extensions_lib.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:meiyou/core/config/routes/router_provider.dart';
import 'package:meiyou/core/utils/resources/modules/injecktor_module.dart';
import 'package:nice_dart/nice_dart.dart';

class AppModule extends InjecktorModule {
  @override
  void inject() {
    // Get.put(
    //   Isar.openSync(
    //     [],
    //     directory: (await DataBaseFolderProvider().path()),
    //     name: 'meiyou.db',
    //   ),
    //   permanent: true,
    // );

    InjectKtor.addSingleton(RouterProvider(), permanent: true);

    InjectKtor.addLazySingleton(
        () => NetworkHelper(InjectKtor.get()).also((it) {
              ExtensionlibOverrides.networkHelper = it;
            }),
        permanent: true);

    InjectKtor.addLazySingleton<ExtensionManager>(() => ExtensionManager(),
        permanent: true);

    InjectKtor.addLazySingleton<SourceManager>(
        () => SourceManager(
            sourcePreferences: InjectKtor.get(), manager: InjectKtor.get()),
        permanent: true);

    InjectKtor.addLazySingleton<SourceRepository>(() => SourceRepositoryImpl(),
        permanent: true);
  }
}
