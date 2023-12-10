import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_full_home_page_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_home_page_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_link_and_media_use_case.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_media_detials_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/search_usecase.dart';

class PluginRepositoryUseCases {
  final LoadFullHomePageUseCase loadFullHomePageUseCase;
  final LoadHomePageUseCase loadHomePageUseCase;
  final LoadSearchUseCase loadSearchUseCase;
  final LoadMediaDetailsUseCase loadMediaDetailsUseCase;
  final LoadLinkAndMediaStreamUseCase loadLinkAndMediaStreamUseCase;

  PluginRepositoryUseCases(PluginRepository repository)
      : loadFullHomePageUseCase = LoadFullHomePageUseCase(repository),
        loadHomePageUseCase = LoadHomePageUseCase(repository),
        loadSearchUseCase = LoadSearchUseCase(repository),
        loadMediaDetailsUseCase = LoadMediaDetailsUseCase(repository),
        loadLinkAndMediaStreamUseCase =
            LoadLinkAndMediaStreamUseCase(repository);
}
