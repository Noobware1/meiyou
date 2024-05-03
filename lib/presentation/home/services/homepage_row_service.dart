import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';

class HomePageRowService {
  final SourceRepository _respository;
  final HomePageRequest _request;
  int page = 1;

  HomePageRowService(this._respository, this._request);

  Future<HomePage> loadNextPage(Source source, HomePage current) async {
    if (!current.hasNextPage) return current;

    page++;
    final result = await _respository.getHomePage(source, page, _request);
    if (result.isSuccess) {
      return current + result.getOrNull()!;
    }
    logRat.logError('Error while loading next Page', result.exceptionOrNull()!);
    return current;
  }
}
