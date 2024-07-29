import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/home_page_data.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:nice_dart/nice_dart.dart';

class GetFulHomePageUseCase
    extends AsyncUseCase<List<HomePageData>, GetFullHomePageParams> {
  final SourceRepository _sourceRepository;

  GetFulHomePageUseCase(this._sourceRepository);

  @override
  Future<Result<List<HomePageData>>> call(GetFullHomePageParams params) =>
      _sourceRepository.getFullHomePage(params);
}
