// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_list.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPluginListCollection on Isar {
  IsarCollection<PluginList> get pluginLists => this.collection();
}

const PluginListSchema = CollectionSchema(
  name: r'PluginList',
  id: 4837398772199963497,
  properties: {
    r'plugins': PropertySchema(
      id: 0,
      name: r'plugins',
      type: IsarType.objectList,
      target: r'EmbedablePlugin',
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _pluginListEstimateSize,
  serialize: _pluginListSerialize,
  deserialize: _pluginListDeserialize,
  deserializeProp: _pluginListDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'EmbedablePlugin': EmbedablePluginSchema,
    r'Dependency': DependencySchema
  },
  getId: _pluginListGetId,
  getLinks: _pluginListGetLinks,
  attach: _pluginListAttach,
  version: '3.1.0+1',
);

int _pluginListEstimateSize(
  PluginList object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.plugins.length * 3;
  {
    final offsets = allOffsets[EmbedablePlugin]!;
    for (var i = 0; i < object.plugins.length; i++) {
      final value = object.plugins[i];
      bytesCount +=
          EmbedablePluginSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _pluginListSerialize(
  PluginList object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<EmbedablePlugin>(
    offsets[0],
    allOffsets,
    EmbedablePluginSchema.serialize,
    object.plugins,
  );
  writer.writeString(offsets[1], object.type);
}

PluginList _pluginListDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PluginList(
    id: id,
    plugins: reader.readObjectList<EmbedablePlugin>(
          offsets[0],
          EmbedablePluginSchema.deserialize,
          allOffsets,
          EmbedablePlugin(),
        ) ??
        [],
    type: reader.readString(offsets[1]),
  );
  return object;
}

P _pluginListDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<EmbedablePlugin>(
            offset,
            EmbedablePluginSchema.deserialize,
            allOffsets,
            EmbedablePlugin(),
          ) ??
          []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pluginListGetId(PluginList object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pluginListGetLinks(PluginList object) {
  return [];
}

void _pluginListAttach(IsarCollection<dynamic> col, Id id, PluginList object) {}

extension PluginListQueryWhereSort
    on QueryBuilder<PluginList, PluginList, QWhere> {
  QueryBuilder<PluginList, PluginList, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PluginListQueryWhere
    on QueryBuilder<PluginList, PluginList, QWhereClause> {
  QueryBuilder<PluginList, PluginList, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PluginList, PluginList, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterWhereClause> idBetween(
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

extension PluginListQueryFilter
    on QueryBuilder<PluginList, PluginList, QFilterCondition> {
  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition>
      pluginsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'plugins',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> pluginsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'plugins',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition>
      pluginsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'plugins',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition>
      pluginsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'plugins',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition>
      pluginsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'plugins',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition>
      pluginsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'plugins',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension PluginListQueryObject
    on QueryBuilder<PluginList, PluginList, QFilterCondition> {
  QueryBuilder<PluginList, PluginList, QAfterFilterCondition> pluginsElement(
      FilterQuery<EmbedablePlugin> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'plugins');
    });
  }
}

extension PluginListQueryLinks
    on QueryBuilder<PluginList, PluginList, QFilterCondition> {}

extension PluginListQuerySortBy
    on QueryBuilder<PluginList, PluginList, QSortBy> {
  QueryBuilder<PluginList, PluginList, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension PluginListQuerySortThenBy
    on QueryBuilder<PluginList, PluginList, QSortThenBy> {
  QueryBuilder<PluginList, PluginList, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PluginList, PluginList, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension PluginListQueryWhereDistinct
    on QueryBuilder<PluginList, PluginList, QDistinct> {
  QueryBuilder<PluginList, PluginList, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension PluginListQueryProperty
    on QueryBuilder<PluginList, PluginList, QQueryProperty> {
  QueryBuilder<PluginList, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PluginList, List<EmbedablePlugin>, QQueryOperations>
      pluginsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plugins');
    });
  }

  QueryBuilder<PluginList, String, QQueryOperations> typeProperty() {
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

const EmbedablePluginSchema = Schema(
  name: r'EmbedablePlugin',
  id: 4791537716842143169,
  properties: {
    r'dependencies': PropertySchema(
      id: 0,
      name: r'dependencies',
      type: IsarType.objectList,
      target: r'Dependency',
    ),
    r'icon': PropertySchema(
      id: 1,
      name: r'icon',
      type: IsarType.string,
    ),
    r'info': PropertySchema(
      id: 2,
      name: r'info',
      type: IsarType.string,
    ),
    r'lastUsed': PropertySchema(
      id: 3,
      name: r'lastUsed',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 5,
      name: r'source',
      type: IsarType.string,
    ),
    r'version': PropertySchema(
      id: 6,
      name: r'version',
      type: IsarType.string,
    )
  },
  estimateSize: _embedablePluginEstimateSize,
  serialize: _embedablePluginSerialize,
  deserialize: _embedablePluginDeserialize,
  deserializeProp: _embedablePluginDeserializeProp,
);

int _embedablePluginEstimateSize(
  EmbedablePlugin object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.dependencies;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Dependency]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              DependencySchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.icon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.info;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.version.length * 3;
  return bytesCount;
}

void _embedablePluginSerialize(
  EmbedablePlugin object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Dependency>(
    offsets[0],
    allOffsets,
    DependencySchema.serialize,
    object.dependencies,
  );
  writer.writeString(offsets[1], object.icon);
  writer.writeString(offsets[2], object.info);
  writer.writeBool(offsets[3], object.lastUsed);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.source);
  writer.writeString(offsets[6], object.version);
}

EmbedablePlugin _embedablePluginDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmbedablePlugin(
    dependencies: reader.readObjectList<Dependency>(
      offsets[0],
      DependencySchema.deserialize,
      allOffsets,
      Dependency(),
    ),
    icon: reader.readStringOrNull(offsets[1]),
    info: reader.readStringOrNull(offsets[2]),
    lastUsed: reader.readBoolOrNull(offsets[3]) ?? false,
    name: reader.readStringOrNull(offsets[4]) ?? '',
    source: reader.readStringOrNull(offsets[5]) ?? '',
    version: reader.readStringOrNull(offsets[6]) ?? '',
  );
  return object;
}

P _embedablePluginDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Dependency>(
        offset,
        DependencySchema.deserialize,
        allOffsets,
        Dependency(),
      )) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EmbedablePluginQueryFilter
    on QueryBuilder<EmbedablePlugin, EmbedablePlugin, QFilterCondition> {
  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dependencies',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dependencies',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dependencies',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dependencies',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dependencies',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dependencies',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dependencies',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dependencies',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'icon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'info',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'info',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'info',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'info',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'info',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'info',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'info',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'info',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'info',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'info',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'info',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      infoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'info',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      lastUsedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'version',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      versionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'version',
        value: '',
      ));
    });
  }
}

extension EmbedablePluginQueryObject
    on QueryBuilder<EmbedablePlugin, EmbedablePlugin, QFilterCondition> {
  QueryBuilder<EmbedablePlugin, EmbedablePlugin, QAfterFilterCondition>
      dependenciesElement(FilterQuery<Dependency> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'dependencies');
    });
  }
}
