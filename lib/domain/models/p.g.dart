// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMovieProgressCollection on Isar {
  IsarCollection<MovieProgress> get movieProgress => this.collection();
}

const MovieProgressSchema = CollectionSchema(
  name: r'MovieProgress',
  id: 8274338365557843419,
  properties: {
    r'durationMilliseconds': PropertySchema(
      id: 0,
      name: r'durationMilliseconds',
      type: IsarType.long,
    ),
    r'positionMilliseconds': PropertySchema(
      id: 1,
      name: r'positionMilliseconds',
      type: IsarType.long,
    ),
    r'sourceId': PropertySchema(
      id: 2,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 3,
      name: r'type',
      type: IsarType.byte,
      enumMap: _MovieProgresstypeEnumValueMap,
    )
  },
  estimateSize: _movieProgressEstimateSize,
  serialize: _movieProgressSerialize,
  deserialize: _movieProgressDeserialize,
  deserializeProp: _movieProgressDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _movieProgressGetId,
  getLinks: _movieProgressGetLinks,
  attach: _movieProgressAttach,
  version: '3.1.0+1',
);

int _movieProgressEstimateSize(
  MovieProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _movieProgressSerialize(
  MovieProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMilliseconds);
  writer.writeLong(offsets[1], object.positionMilliseconds);
  writer.writeLong(offsets[2], object.sourceId);
  writer.writeByte(offsets[3], object.type.index);
}

MovieProgress _movieProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MovieProgress(
    durationMilliseconds: reader.readLong(offsets[0]),
    id: id,
    positionMilliseconds: reader.readLong(offsets[1]),
    sourceId: reader.readLong(offsets[2]),
    type: _MovieProgresstypeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
        ExtensionType.Video,
  );
  return object;
}

P _movieProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (_MovieProgresstypeValueEnumMap[reader.readByteOrNull(offset)] ??
          ExtensionType.Video) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MovieProgresstypeEnumValueMap = {
  'Video': 0,
  'Manga': 1,
  'Novel': 2,
};
const _MovieProgresstypeValueEnumMap = {
  0: ExtensionType.Video,
  1: ExtensionType.Manga,
  2: ExtensionType.Novel,
};

Id _movieProgressGetId(MovieProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _movieProgressGetLinks(MovieProgress object) {
  return [];
}

void _movieProgressAttach(
    IsarCollection<dynamic> col, Id id, MovieProgress object) {}

extension MovieProgressQueryWhereSort
    on QueryBuilder<MovieProgress, MovieProgress, QWhere> {
  QueryBuilder<MovieProgress, MovieProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MovieProgressQueryWhere
    on QueryBuilder<MovieProgress, MovieProgress, QWhereClause> {
  QueryBuilder<MovieProgress, MovieProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MovieProgressQueryFilter
    on QueryBuilder<MovieProgress, MovieProgress, QFilterCondition> {
  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      durationMillisecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      durationMillisecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      durationMillisecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      durationMillisecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMilliseconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      positionMillisecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      positionMillisecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      positionMillisecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      positionMillisecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionMilliseconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      sourceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      sourceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      sourceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      sourceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition> typeEqualTo(
      ExtensionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      typeGreaterThan(
    ExtensionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition>
      typeLessThan(
    ExtensionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterFilterCondition> typeBetween(
    ExtensionType lower,
    ExtensionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MovieProgressQueryObject
    on QueryBuilder<MovieProgress, MovieProgress, QFilterCondition> {}

extension MovieProgressQueryLinks
    on QueryBuilder<MovieProgress, MovieProgress, QFilterCondition> {}

extension MovieProgressQuerySortBy
    on QueryBuilder<MovieProgress, MovieProgress, QSortBy> {
  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      sortByDurationMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      sortByDurationMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      sortByPositionMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      sortByPositionMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MovieProgressQuerySortThenBy
    on QueryBuilder<MovieProgress, MovieProgress, QSortThenBy> {
  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      thenByDurationMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      thenByDurationMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      thenByPositionMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      thenByPositionMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MovieProgressQueryWhereDistinct
    on QueryBuilder<MovieProgress, MovieProgress, QDistinct> {
  QueryBuilder<MovieProgress, MovieProgress, QDistinct>
      distinctByDurationMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMilliseconds');
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QDistinct>
      distinctByPositionMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMilliseconds');
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QDistinct> distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<MovieProgress, MovieProgress, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension MovieProgressQueryProperty
    on QueryBuilder<MovieProgress, MovieProgress, QQueryProperty> {
  QueryBuilder<MovieProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MovieProgress, int, QQueryOperations>
      durationMillisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMilliseconds');
    });
  }

  QueryBuilder<MovieProgress, int, QQueryOperations>
      positionMillisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMilliseconds');
    });
  }

  QueryBuilder<MovieProgress, int, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<MovieProgress, ExtensionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAnimeProgressCollection on Isar {
  IsarCollection<AnimeProgress> get animeProgress => this.collection();
}

const AnimeProgressSchema = CollectionSchema(
  name: r'AnimeProgress',
  id: 6363471039508679652,
  properties: {
    r'episodeIndex': PropertySchema(
      id: 0,
      name: r'episodeIndex',
      type: IsarType.long,
    ),
    r'episodeListIndex': PropertySchema(
      id: 1,
      name: r'episodeListIndex',
      type: IsarType.long,
    ),
    r'episodeProgress': PropertySchema(
      id: 2,
      name: r'episodeProgress',
      type: IsarType.objectList,
      target: r'EmbedProgress',
    ),
    r'sourceId': PropertySchema(
      id: 3,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 4,
      name: r'type',
      type: IsarType.byte,
      enumMap: _AnimeProgresstypeEnumValueMap,
    )
  },
  estimateSize: _animeProgressEstimateSize,
  serialize: _animeProgressSerialize,
  deserialize: _animeProgressDeserialize,
  deserializeProp: _animeProgressDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'EmbedProgress': EmbedProgressSchema},
  getId: _animeProgressGetId,
  getLinks: _animeProgressGetLinks,
  attach: _animeProgressAttach,
  version: '3.1.0+1',
);

int _animeProgressEstimateSize(
  AnimeProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.episodeProgress.length * 3;
  {
    final offsets = allOffsets[EmbedProgress]!;
    for (var i = 0; i < object.episodeProgress.length; i++) {
      final value = object.episodeProgress[i];
      bytesCount +=
          EmbedProgressSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _animeProgressSerialize(
  AnimeProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.episodeIndex);
  writer.writeLong(offsets[1], object.episodeListIndex);
  writer.writeObjectList<EmbedProgress>(
    offsets[2],
    allOffsets,
    EmbedProgressSchema.serialize,
    object.episodeProgress,
  );
  writer.writeLong(offsets[3], object.sourceId);
  writer.writeByte(offsets[4], object.type.index);
}

AnimeProgress _animeProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AnimeProgress(
    episodeIndex: reader.readLong(offsets[0]),
    episodeListIndex: reader.readLong(offsets[1]),
    episodeProgress: reader.readObjectList<EmbedProgress>(
          offsets[2],
          EmbedProgressSchema.deserialize,
          allOffsets,
          EmbedProgress(),
        ) ??
        [],
    id: id,
    sourceId: reader.readLong(offsets[3]),
    type: _AnimeProgresstypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
        ExtensionType.Video,
  );
  return object;
}

P _animeProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readObjectList<EmbedProgress>(
            offset,
            EmbedProgressSchema.deserialize,
            allOffsets,
            EmbedProgress(),
          ) ??
          []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (_AnimeProgresstypeValueEnumMap[reader.readByteOrNull(offset)] ??
          ExtensionType.Video) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AnimeProgresstypeEnumValueMap = {
  'Video': 0,
  'Manga': 1,
  'Novel': 2,
};
const _AnimeProgresstypeValueEnumMap = {
  0: ExtensionType.Video,
  1: ExtensionType.Manga,
  2: ExtensionType.Novel,
};

Id _animeProgressGetId(AnimeProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _animeProgressGetLinks(AnimeProgress object) {
  return [];
}

void _animeProgressAttach(
    IsarCollection<dynamic> col, Id id, AnimeProgress object) {}

extension AnimeProgressQueryWhereSort
    on QueryBuilder<AnimeProgress, AnimeProgress, QWhere> {
  QueryBuilder<AnimeProgress, AnimeProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AnimeProgressQueryWhere
    on QueryBuilder<AnimeProgress, AnimeProgress, QWhereClause> {
  QueryBuilder<AnimeProgress, AnimeProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AnimeProgressQueryFilter
    on QueryBuilder<AnimeProgress, AnimeProgress, QFilterCondition> {
  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeListIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeListIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeListIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeListIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeListIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeListIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeListIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeListIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeProgressLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeProgressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeProgressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeProgressLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeProgressLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeProgressLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      sourceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      sourceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      sourceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      sourceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition> typeEqualTo(
      ExtensionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      typeGreaterThan(
    ExtensionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      typeLessThan(
    ExtensionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition> typeBetween(
    ExtensionType lower,
    ExtensionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AnimeProgressQueryObject
    on QueryBuilder<AnimeProgress, AnimeProgress, QFilterCondition> {
  QueryBuilder<AnimeProgress, AnimeProgress, QAfterFilterCondition>
      episodeProgressElement(FilterQuery<EmbedProgress> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'episodeProgress');
    });
  }
}

extension AnimeProgressQueryLinks
    on QueryBuilder<AnimeProgress, AnimeProgress, QFilterCondition> {}

extension AnimeProgressQuerySortBy
    on QueryBuilder<AnimeProgress, AnimeProgress, QSortBy> {
  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      sortByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      sortByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      sortByEpisodeListIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      sortByEpisodeListIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.desc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AnimeProgressQuerySortThenBy
    on QueryBuilder<AnimeProgress, AnimeProgress, QSortThenBy> {
  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      thenByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      thenByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      thenByEpisodeListIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      thenByEpisodeListIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.desc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AnimeProgressQueryWhereDistinct
    on QueryBuilder<AnimeProgress, AnimeProgress, QDistinct> {
  QueryBuilder<AnimeProgress, AnimeProgress, QDistinct>
      distinctByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeIndex');
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QDistinct>
      distinctByEpisodeListIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeListIndex');
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QDistinct> distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<AnimeProgress, AnimeProgress, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension AnimeProgressQueryProperty
    on QueryBuilder<AnimeProgress, AnimeProgress, QQueryProperty> {
  QueryBuilder<AnimeProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AnimeProgress, int, QQueryOperations> episodeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeIndex');
    });
  }

  QueryBuilder<AnimeProgress, int, QQueryOperations>
      episodeListIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeListIndex');
    });
  }

  QueryBuilder<AnimeProgress, List<EmbedProgress>, QQueryOperations>
      episodeProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeProgress');
    });
  }

  QueryBuilder<AnimeProgress, int, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<AnimeProgress, ExtensionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSeriesProgressCollection on Isar {
  IsarCollection<SeriesProgress> get seriesProgress => this.collection();
}

const SeriesProgressSchema = CollectionSchema(
  name: r'SeriesProgress',
  id: 5332940780930267483,
  properties: {
    r'episodeIndex': PropertySchema(
      id: 0,
      name: r'episodeIndex',
      type: IsarType.long,
    ),
    r'episodeListIndex': PropertySchema(
      id: 1,
      name: r'episodeListIndex',
      type: IsarType.long,
    ),
    r'seasonIndex': PropertySchema(
      id: 2,
      name: r'seasonIndex',
      type: IsarType.long,
    ),
    r'seasonProgress': PropertySchema(
      id: 3,
      name: r'seasonProgress',
      type: IsarType.objectList,
      target: r'EmebedSeasonProgress',
    ),
    r'sourceId': PropertySchema(
      id: 4,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _SeriesProgresstypeEnumValueMap,
    )
  },
  estimateSize: _seriesProgressEstimateSize,
  serialize: _seriesProgressSerialize,
  deserialize: _seriesProgressDeserialize,
  deserializeProp: _seriesProgressDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'EmebedSeasonProgress': EmebedSeasonProgressSchema,
    r'EmbedProgress': EmbedProgressSchema
  },
  getId: _seriesProgressGetId,
  getLinks: _seriesProgressGetLinks,
  attach: _seriesProgressAttach,
  version: '3.1.0+1',
);

int _seriesProgressEstimateSize(
  SeriesProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.seasonProgress.length * 3;
  {
    final offsets = allOffsets[EmebedSeasonProgress]!;
    for (var i = 0; i < object.seasonProgress.length; i++) {
      final value = object.seasonProgress[i];
      bytesCount +=
          EmebedSeasonProgressSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _seriesProgressSerialize(
  SeriesProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.episodeIndex);
  writer.writeLong(offsets[1], object.episodeListIndex);
  writer.writeLong(offsets[2], object.seasonIndex);
  writer.writeObjectList<EmebedSeasonProgress>(
    offsets[3],
    allOffsets,
    EmebedSeasonProgressSchema.serialize,
    object.seasonProgress,
  );
  writer.writeLong(offsets[4], object.sourceId);
  writer.writeByte(offsets[5], object.type.index);
}

SeriesProgress _seriesProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SeriesProgress(
    episodeIndex: reader.readLong(offsets[0]),
    episodeListIndex: reader.readLong(offsets[1]),
    id: id,
    seasonIndex: reader.readLong(offsets[2]),
    seasonProgress: reader.readObjectList<EmebedSeasonProgress>(
          offsets[3],
          EmebedSeasonProgressSchema.deserialize,
          allOffsets,
          EmebedSeasonProgress(),
        ) ??
        [],
    sourceId: reader.readLong(offsets[4]),
    type: _SeriesProgresstypeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
        ExtensionType.Video,
  );
  return object;
}

P _seriesProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readObjectList<EmebedSeasonProgress>(
            offset,
            EmebedSeasonProgressSchema.deserialize,
            allOffsets,
            EmebedSeasonProgress(),
          ) ??
          []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (_SeriesProgresstypeValueEnumMap[reader.readByteOrNull(offset)] ??
          ExtensionType.Video) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SeriesProgresstypeEnumValueMap = {
  'Video': 0,
  'Manga': 1,
  'Novel': 2,
};
const _SeriesProgresstypeValueEnumMap = {
  0: ExtensionType.Video,
  1: ExtensionType.Manga,
  2: ExtensionType.Novel,
};

Id _seriesProgressGetId(SeriesProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _seriesProgressGetLinks(SeriesProgress object) {
  return [];
}

void _seriesProgressAttach(
    IsarCollection<dynamic> col, Id id, SeriesProgress object) {}

extension SeriesProgressQueryWhereSort
    on QueryBuilder<SeriesProgress, SeriesProgress, QWhere> {
  QueryBuilder<SeriesProgress, SeriesProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SeriesProgressQueryWhere
    on QueryBuilder<SeriesProgress, SeriesProgress, QWhereClause> {
  QueryBuilder<SeriesProgress, SeriesProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeriesProgressQueryFilter
    on QueryBuilder<SeriesProgress, SeriesProgress, QFilterCondition> {
  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeListIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeListIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeListIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeListIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeListIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeListIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      episodeListIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeListIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonProgressLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonProgress',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonProgressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonProgress',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonProgressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonProgress',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonProgressLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonProgress',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonProgressLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonProgress',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonProgressLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonProgress',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      sourceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      sourceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      sourceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      sourceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      typeEqualTo(ExtensionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      typeGreaterThan(
    ExtensionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      typeLessThan(
    ExtensionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      typeBetween(
    ExtensionType lower,
    ExtensionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeriesProgressQueryObject
    on QueryBuilder<SeriesProgress, SeriesProgress, QFilterCondition> {
  QueryBuilder<SeriesProgress, SeriesProgress, QAfterFilterCondition>
      seasonProgressElement(FilterQuery<EmebedSeasonProgress> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'seasonProgress');
    });
  }
}

extension SeriesProgressQueryLinks
    on QueryBuilder<SeriesProgress, SeriesProgress, QFilterCondition> {}

extension SeriesProgressQuerySortBy
    on QueryBuilder<SeriesProgress, SeriesProgress, QSortBy> {
  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      sortByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      sortByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      sortByEpisodeListIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      sortByEpisodeListIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      sortBySeasonIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonIndex', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      sortBySeasonIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonIndex', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SeriesProgressQuerySortThenBy
    on QueryBuilder<SeriesProgress, SeriesProgress, QSortThenBy> {
  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      thenByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      thenByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      thenByEpisodeListIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      thenByEpisodeListIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeListIndex', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      thenBySeasonIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonIndex', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      thenBySeasonIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonIndex', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension SeriesProgressQueryWhereDistinct
    on QueryBuilder<SeriesProgress, SeriesProgress, QDistinct> {
  QueryBuilder<SeriesProgress, SeriesProgress, QDistinct>
      distinctByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeIndex');
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QDistinct>
      distinctByEpisodeListIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeListIndex');
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QDistinct>
      distinctBySeasonIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasonIndex');
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QDistinct> distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<SeriesProgress, SeriesProgress, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension SeriesProgressQueryProperty
    on QueryBuilder<SeriesProgress, SeriesProgress, QQueryProperty> {
  QueryBuilder<SeriesProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SeriesProgress, int, QQueryOperations> episodeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeIndex');
    });
  }

  QueryBuilder<SeriesProgress, int, QQueryOperations>
      episodeListIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeListIndex');
    });
  }

  QueryBuilder<SeriesProgress, int, QQueryOperations> seasonIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonIndex');
    });
  }

  QueryBuilder<SeriesProgress, List<EmebedSeasonProgress>, QQueryOperations>
      seasonProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonProgress');
    });
  }

  QueryBuilder<SeriesProgress, int, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<SeriesProgress, ExtensionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const EmbedProgressSchema = Schema(
  name: r'EmbedProgress',
  id: -4996971423672834710,
  properties: {
    r'durationMilliseconds': PropertySchema(
      id: 0,
      name: r'durationMilliseconds',
      type: IsarType.long,
    ),
    r'positionMilliseconds': PropertySchema(
      id: 1,
      name: r'positionMilliseconds',
      type: IsarType.long,
    )
  },
  estimateSize: _embedProgressEstimateSize,
  serialize: _embedProgressSerialize,
  deserialize: _embedProgressDeserialize,
  deserializeProp: _embedProgressDeserializeProp,
);

int _embedProgressEstimateSize(
  EmbedProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _embedProgressSerialize(
  EmbedProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMilliseconds);
  writer.writeLong(offsets[1], object.positionMilliseconds);
}

EmbedProgress _embedProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmbedProgress(
    durationMilliseconds: reader.readLongOrNull(offsets[0]) ?? -1,
    positionMilliseconds: reader.readLongOrNull(offsets[1]) ?? -1,
  );
  return object;
}

P _embedProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EmbedProgressQueryFilter
    on QueryBuilder<EmbedProgress, EmbedProgress, QFilterCondition> {
  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      durationMillisecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      durationMillisecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      durationMillisecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      durationMillisecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMilliseconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      positionMillisecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      positionMillisecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      positionMillisecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionMilliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbedProgress, EmbedProgress, QAfterFilterCondition>
      positionMillisecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionMilliseconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EmbedProgressQueryObject
    on QueryBuilder<EmbedProgress, EmbedProgress, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const EmebedSeasonProgressSchema = Schema(
  name: r'EmebedSeasonProgress',
  id: 7747362789691518084,
  properties: {
    r'episodeProgress': PropertySchema(
      id: 0,
      name: r'episodeProgress',
      type: IsarType.objectList,
      target: r'EmbedProgress',
    ),
    r'seasonIndex': PropertySchema(
      id: 1,
      name: r'seasonIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _emebedSeasonProgressEstimateSize,
  serialize: _emebedSeasonProgressSerialize,
  deserialize: _emebedSeasonProgressDeserialize,
  deserializeProp: _emebedSeasonProgressDeserializeProp,
);

int _emebedSeasonProgressEstimateSize(
  EmebedSeasonProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.episodeProgress.length * 3;
  {
    final offsets = allOffsets[EmbedProgress]!;
    for (var i = 0; i < object.episodeProgress.length; i++) {
      final value = object.episodeProgress[i];
      bytesCount +=
          EmbedProgressSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _emebedSeasonProgressSerialize(
  EmebedSeasonProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<EmbedProgress>(
    offsets[0],
    allOffsets,
    EmbedProgressSchema.serialize,
    object.episodeProgress,
  );
  writer.writeLong(offsets[1], object.seasonIndex);
}

EmebedSeasonProgress _emebedSeasonProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmebedSeasonProgress(
    episodeProgress: reader.readObjectList<EmbedProgress>(
          offsets[0],
          EmbedProgressSchema.deserialize,
          allOffsets,
          EmbedProgress(),
        ) ??
        const [],
    seasonIndex: reader.readLongOrNull(offsets[1]) ?? -1,
  );
  return object;
}

P _emebedSeasonProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<EmbedProgress>(
            offset,
            EmbedProgressSchema.deserialize,
            allOffsets,
            EmbedProgress(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EmebedSeasonProgressQueryFilter on QueryBuilder<EmebedSeasonProgress,
    EmebedSeasonProgress, QFilterCondition> {
  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> episodeProgressLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> episodeProgressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> episodeProgressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> episodeProgressLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> episodeProgressLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> episodeProgressLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'episodeProgress',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> seasonIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> seasonIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> seasonIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
      QAfterFilterCondition> seasonIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EmebedSeasonProgressQueryObject on QueryBuilder<EmebedSeasonProgress,
    EmebedSeasonProgress, QFilterCondition> {
  QueryBuilder<EmebedSeasonProgress, EmebedSeasonProgress,
          QAfterFilterCondition>
      episodeProgressElement(FilterQuery<EmbedProgress> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'episodeProgress');
    });
  }
}
