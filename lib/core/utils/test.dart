import 'dart:convert';

import 'package:meiyou/core/resources/queries.dart';

const query = '''
query(\$page: Int, \$search: String, \$isAdult:Boolean)
{
  Page(page: \$page, perPage: 50) {
    pageInfo {
      total,
      hasNextPage
    }
    media(search: \$search, type: ANIME, format_not_in: [MUSIC, TV_SHORT, NOVEL, ONE_SHOT], isAdult: \$isAdult) {
      id
      title {
        romaji
        english
        native
        userPreferred
      }
      coverImage {
        extraLarge,
        large,
        medium,
      }
      startDate {
        year
        month
        day
      }
      endDate {
        year
        month
        day
      }
      genres
      description
      bannerImage
      format
      idMal
      status
      nextAiringEpisode {
        episode
      }
      episodes
    }
  }
}
''';

const l = '''
query(\$search: String, \$isAdult: Boolean) {

}
''';

void main(List<String> args) async {
  const a = "Ao-chan Can't Study!";
  // print(generateSearchQuery(a));

  final b = jsonEncode(generateSearchQuery(a));

  print(b);

  print(generateSearchQuery(a));
}
