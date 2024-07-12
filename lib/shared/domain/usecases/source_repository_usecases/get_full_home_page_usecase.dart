import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class GetFulHomePageUseCase
    extends AsyncUsecase<FullHomePageData, GetFullHomePageParams> {
  final SourceRepository _sourceRepository;

  GetFulHomePageUseCase(this._sourceRepository);

  @override
  Future<Result<FullHomePageData>> call(GetFullHomePageParams params) =>
      _sourceRepository.getFullHomePage(params);
}
