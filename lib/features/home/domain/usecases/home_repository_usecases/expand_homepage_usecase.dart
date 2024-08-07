import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/features/home/domain/models/expanded_home_page_list.dart';
import 'package:meiyou/features/home/domain/models/repository_params/home_page_repository_params.dart';
import 'package:meiyou/features/home/domain/repositories/home_repository.dart';

class ExpandHomepageUseCase
    extends UseCase<Future<List<ExpandedHomePageList>>, ExpandHomePageParams> {
  final HomeRepository _homeRepository;

  ExpandHomepageUseCase(this._homeRepository);

  @override
  Future<List<ExpandedHomePageList>> call(ExpandHomePageParams params) {
    return _homeRepository.expandHomePage(params);
  }
}
