// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLibraryItemCollection on Isar {
  IsarCollection<LibraryItem> get libraryItems => this.collection();
}

const LibraryItemSchema = CollectionSchema(
  name: r'LibraryItem',
  id: 1070397465224955633,
  properties: {
    r'contentProgressEncoded': PropertySchema(
      id: 0,
      name: r'contentProgressEncoded',
      type: IsarType.string,
    ),
    r'poster': PropertySchema(
      id: 1,
      name: r'poster',
      type: IsarType.string,
    ),
    r'seenCount': PropertySchema(
      id: 2,
      name: r'seenCount',
      type: IsarType.long,
    ),
    r'sourceId': PropertySchema(
      id: 3,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 4,
      name: r'title',
      type: IsarType.string,
    ),
    r'total': PropertySchema(
      id: 5,
      name: r'total',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.byte,
      enumMap: _LibraryItemtypeEnumValueMap,
    ),
    r'url': PropertySchema(
      id: 7,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _libraryItemEstimateSize,
  serialize: _libraryItemSerialize,
  deserialize: _libraryItemDeserialize,
  deserializeProp: _libraryItemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _libraryItemGetId,
  getLinks: _libraryItemGetLinks,
  attach: _libraryItemAttach,
  version: '3.1.0+1',
);

int _libraryItemEstimateSize(
  LibraryItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.contentProgressEncoded;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.poster;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _libraryItemSerialize(
  LibraryItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.contentProgressEncoded);
  writer.writeString(offsets[1], object.poster);
  writer.writeLong(offsets[2], object.seenCount);
  writer.writeLong(offsets[3], object.sourceId);
  writer.writeString(offsets[4], object.title);
  writer.writeLong(offsets[5], object.total);
  writer.writeByte(offsets[6], object.type.index);
  writer.writeString(offsets[7], object.url);
}

LibraryItem _libraryItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LibraryItem(
    contentProgressEncoded: reader.readStringOrNull(offsets[0]),
    id: id,
    poster: reader.readStringOrNull(offsets[1]),
    seenCount: reader.readLongOrNull(offsets[2]),
    sourceId: reader.readLong(offsets[3]),
    title: reader.readString(offsets[4]),
    total: reader.readLongOrNull(offsets[5]),
    type: _LibraryItemtypeValueEnumMap[reader.readByteOrNull(offsets[6])] ??
        ExtensionType.Video,
    url: reader.readString(offsets[7]),
  );
  return object;
}

P _libraryItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (_LibraryItemtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          ExtensionType.Video) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LibraryItemtypeEnumValueMap = {
  'Video': 0,
  'Manga': 1,
  'Novel': 2,
};
const _LibraryItemtypeValueEnumMap = {
  0: ExtensionType.Video,
  1: ExtensionType.Manga,
  2: ExtensionType.Novel,
};

Id _libraryItemGetId(LibraryItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _libraryItemGetLinks(LibraryItem object) {
  return [];
}

void _libraryItemAttach(
    IsarCollection<dynamic> col, Id id, LibraryItem object) {}

extension LibraryItemQueryWhereSort
    on QueryBuilder<LibraryItem, LibraryItem, QWhere> {
  QueryBuilder<LibraryItem, LibraryItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LibraryItemQueryWhere
    on QueryBuilder<LibraryItem, LibraryItem, QWhereClause> {
  QueryBuilder<LibraryItem, LibraryItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterWhereClause> idBetween(
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

extension LibraryItemQueryFilter
    on QueryBuilder<LibraryItem, LibraryItem, QFilterCondition> {
  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contentProgressEncoded',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contentProgressEncoded',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentProgressEncoded',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentProgressEncoded',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentProgressEncoded',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentProgressEncoded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentProgressEncoded',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentProgressEncoded',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentProgressEncoded',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentProgressEncoded',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentProgressEncoded',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      contentProgressEncodedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentProgressEncoded',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> posterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'poster',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      posterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'poster',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> posterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      posterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> posterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> posterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poster',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      posterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> posterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> posterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> posterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'poster',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      posterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poster',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      posterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'poster',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      seenCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seenCount',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      seenCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seenCount',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      seenCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      seenCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      seenCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      seenCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seenCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> sourceIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> sourceIdBetween(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> totalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'total',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      totalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'total',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> totalEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'total',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      totalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'total',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> totalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'total',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> totalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'total',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> typeEqualTo(
      ExtensionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterFilterCondition>
      urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension LibraryItemQueryObject
    on QueryBuilder<LibraryItem, LibraryItem, QFilterCondition> {}

extension LibraryItemQueryLinks
    on QueryBuilder<LibraryItem, LibraryItem, QFilterCondition> {}

extension LibraryItemQuerySortBy
    on QueryBuilder<LibraryItem, LibraryItem, QSortBy> {
  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy>
      sortByContentProgressEncoded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentProgressEncoded', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy>
      sortByContentProgressEncodedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentProgressEncoded', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByPoster() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByPosterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortBySeenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortBySeenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension LibraryItemQuerySortThenBy
    on QueryBuilder<LibraryItem, LibraryItem, QSortThenBy> {
  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy>
      thenByContentProgressEncoded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentProgressEncoded', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy>
      thenByContentProgressEncodedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentProgressEncoded', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByPoster() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByPosterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenBySeenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenBySeenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension LibraryItemQueryWhereDistinct
    on QueryBuilder<LibraryItem, LibraryItem, QDistinct> {
  QueryBuilder<LibraryItem, LibraryItem, QDistinct>
      distinctByContentProgressEncoded({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentProgressEncoded',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QDistinct> distinctByPoster(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poster', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QDistinct> distinctBySeenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seenCount');
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QDistinct> distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QDistinct> distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<LibraryItem, LibraryItem, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension LibraryItemQueryProperty
    on QueryBuilder<LibraryItem, LibraryItem, QQueryProperty> {
  QueryBuilder<LibraryItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LibraryItem, String?, QQueryOperations>
      contentProgressEncodedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentProgressEncoded');
    });
  }

  QueryBuilder<LibraryItem, String?, QQueryOperations> posterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poster');
    });
  }

  QueryBuilder<LibraryItem, int?, QQueryOperations> seenCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seenCount');
    });
  }

  QueryBuilder<LibraryItem, int, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<LibraryItem, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<LibraryItem, int?, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }

  QueryBuilder<LibraryItem, ExtensionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<LibraryItem, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}
