String generateSearchQuery(String name, [int? page, int? perPage]) {
  String query = '''
{
  Page(page: 1, perPage: ${perPage ?? 50}) {
    pageInfo {
      total,
      hasNextPage
    }
    media(search: "$name", type: ANIME, format_not_in: [MUSIC, TV_SHORT, NOVEL, ONE_SHOT], isAdult: false) {
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

  return query;
}

String generateMediaQuery(int id) => '''
{
  Media(id: $id, type: ANIME) {
    id
    title {
      romaji
      english
      native
      userPreferred
    }
    coverImage {
      extraLarge
      large
      medium
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
    bannerImage
    format
    genres
    meanScore
    description
    idMal
    status
    nextAiringEpisode {
      episode
    }
    episodes
    characters {
      edges {
        role
        node {
          id
          name {
            first
            middle
            last
            full
            native
            userPreferred
          }
          image {
            large
            medium
          }
        }
      }
    }
    recommendations(sort: RATING_DESC, page: 1, perPage: 50) {
      edges {
        node {
          id
          mediaRecommendation {
            id
            title {
              romaji
              english
              native
              userPreferred
            }
            coverImage {
              extraLarge
              large
              medium
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
    }
  }
}
''';

String generateTrendingQuery([int page = 1]) => '''
{
  Page(page: $page, perPage: 50) {
    pageInfo {
      total,
      hasNextPage
    }
    media(sort: TRENDING_DESC, type: ANIME, format_not_in: [MUSIC, TV_SHORT, NOVEL, ONE_SHOT], isAdult: false) {
      id
      title {
        romaji
        english
        native
        userPreferred
      }
      coverImage {
        extraLarge
        large
        medium
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
      meanScore
      isAdult
      countryOfOrigin
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

String generatePopularQuery([int page = 1]) => '''
{
  Page(page: $page, perPage: 50) {
    pageInfo {
      total,
      hasNextPage
    }
    media(sort: POPULARITY_DESC, type: ANIME, format_not_in: [MUSIC, TV_SHORT, NOVEL, ONE_SHOT], isAdult: false) {
      id
      title {
        romaji
        english
        native
        userPreferred
      }
      coverImage {
        extraLarge
        large
        medium
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
      countryOfOrigin
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

String generateRecentlyAdded(
    {bool smaller = true, int greater = 0, int? lesser, int page = 1}) {
  lesser ??= DateTime.now().millisecondsSinceEpoch ~/ 1000 - 10000;

  final query = '''
{
  Page(page: $page, perPage: 50) {
    pageInfo {
      hasNextPage
      total
    }
    airingSchedules(airingAt_greater: $greater, airingAt_lesser: $lesser, sort: TIME_DESC) {
      episode
      airingAt
      media {
        id
        idMal
        status
        episodes
        nextAiringEpisode {
          episode
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
        isAdult
        format
        type
        description
        meanScore
        bannerImage
        countryOfOrigin
        coverImage {
          large
        }
        title {
          english
          romaji
          userPreferred
        }
      }
    }
  }
}
''';
  return query;
}
