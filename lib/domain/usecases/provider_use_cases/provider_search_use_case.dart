import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/future_use_case.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class ProviderSearchParams {
  final BaseProvider provider;
  final String? query;
  final MediaDetailsEntity? media;

  const ProviderSearchParams({this.query, this.media, required this.provider});
}

class ProviderSearchUseCase
    implements FutureUseCase<List<SearchResponseEntity>, ProviderSearchParams> {
  final WatchProviderRepository repository;

  const ProviderSearchUseCase(this.repository);

  @override
  Future<ResponseState<List<SearchResponseEntity>>> call(
      ProviderSearchParams params) {
    return repository.search(params.provider, query: params.query);
  }
}
