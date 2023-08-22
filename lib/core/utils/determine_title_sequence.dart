import 'package:meiyou/core/resources/providers/anime_provider.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';

String determineTitleSequence(BaseProvider provider, List<String?> titles) {
  final String? title;
  if (provider is AnimeProvider) {
    title = titles[1] ?? titles[0] ?? titles[2];
  } else {
    title = titles[0] ?? titles[2];
  }
  return title ?? '';
}
