import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/gogo.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/repositories/cache_repository_impl.dart';
import 'package:meiyou/data/repositories/meta_provider_repository_impl.dart';
import 'package:meiyou/data/repositories/watch_provider_repository_impl.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/presentation/pages/info_watch/state/read_json.dart';

final CacheRespository cacheRespository =
    CacheRepositoryImpl('E:\\Projects\\meiyou\\lib\\config');
void main(List<String> args) async {
  // final info = await MetaProviderRepositoryImpl(TMDB(), Anilist())
  //     .fetchMediaDetails(const MetaResponseEntity(
  //         id: 149883,
  //         //anime
  //         //wednesday
  //         //119051,
  //         mediaType: 'tv',
  //         mediaProvider: MediaProvider.anilist,
  //         genres: ['']));
  final info = readMedia();

  final WatchProviderRepository watchProviderRepository =
      WatchProviderRepositoryImpl(info);

  final provider = Gogo();

  final search =
      await watchProviderRepository.searchWithQuery(provider, info.mediaTitle);
  search.data?.forEach(print);
// final seasons = await w'
  final episodes = await watchProviderRepository.loadEpisodes(
      provider: provider,
      url: search.data!.first.url,
      cacheRespository: cacheRespository);

  episodes.data?.forEach(print);
}
