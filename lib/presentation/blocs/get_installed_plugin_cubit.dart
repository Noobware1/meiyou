import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/get_installed_plugins_usecase.dart';

sealed class InstalledPluginCubit extends Cubit<List<InstalledPluginEntity>> {
  late final StreamSubscription _subtscription;

  InstalledPluginCubit(Stream<List<InstalledPluginEntity>> stream) : super([]) {
    _subtscription = stream.listen((plugins) {
      emit(plugins);
    });
  }

  @override
  Future<void> close() {
    _subtscription.cancel();
    return super.close();
  }
}

final class InstalledVideoPluginCubit extends InstalledPluginCubit {
  InstalledVideoPluginCubit(GetInstalledPluginsUseCase useCase)
      : super(useCase('Video'));
}

final class InstalledMangaPluginCubit extends InstalledPluginCubit {
  InstalledMangaPluginCubit(GetInstalledPluginsUseCase useCase)
      : super(useCase('Manga'));
}

final class InstalledNovelPluginCubit extends InstalledPluginCubit {
  InstalledNovelPluginCubit(GetInstalledPluginsUseCase useCase)
      : super(useCase('Novel'));
}
