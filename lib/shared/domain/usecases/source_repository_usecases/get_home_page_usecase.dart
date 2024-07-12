import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class GetHomePageUseCase
    extends AsyncUsecase<HomePage, GetHomePageParams> {
  final SourceRepository _sourceRepository;

  GetHomePageUseCase(this._sourceRepository);

  @override
  Future<Result<HomePage>> call(GetHomePageParams params) =>
      _sourceRepository.getHomePage(params);
}
