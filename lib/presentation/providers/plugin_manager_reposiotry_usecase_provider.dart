import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_full_home_page_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_home_page_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_link_and_media_use_case.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_media_detials_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/search_usecase.dart';

class PluginManagerUseCaseProvider {
  final LoadFullHomePageUseCase loadFullHomePageUseCase;
  final LoadHomePageUseCase loadHomePageUseCase;
  final LoadSearchUseCase loadSearchUseCase;
  final LoadMediaDetailsUseCase loadMediaDetailsUseCase;
  final LoadLinkAndMediaStreamUseCase loadLinkAndMediaStreamUseCase;

  PluginManagerUseCaseProvider(PluginManagerRepository repository)
      : loadFullHomePageUseCase = LoadFullHomePageUseCase(repository),
        loadHomePageUseCase = LoadHomePageUseCase(repository),
        loadSearchUseCase = LoadSearchUseCase(repository),
        loadMediaDetailsUseCase = LoadMediaDetailsUseCase(repository),
        loadLinkAndMediaStreamUseCase =
            LoadLinkAndMediaStreamUseCase(repository);
}
