import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/data/data_source/providers/providers.dart';
import 'package:meiyou/domain/repositories/get_providers_list.dart';

class GetProviderListRepositoryImpl implements GetProviderListRepository {
  @override
  Map<String, BaseProvider> getProviderList(String mediaType) {
    final ProviderType type;
    if (mediaType == MediaType.movie || mediaType == MediaType.tvShow) {
      type = ProviderType.movie;
    } else {
      type = ProviderType.anime;
    }

    switch (type) {
      case ProviderType.anime:
        return AnimeProviders().providers;
      case ProviderType.movie:
        return  
        MovieProviders().providers;

      default:
        return {};
    }
  }
}
