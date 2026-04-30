// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDecisionLogCollection on Isar {
  IsarCollection<DecisionLog> get decisionLogs => this.collection();
}

const DecisionLogSchema = CollectionSchema(
  name: r'DecisionLog',
  id: -3953042704646498711,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isPaylater': PropertySchema(
      id: 1,
      name: r'isPaylater',
      type: IsarType.bool,
    ),
    r'itemName': PropertySchema(
      id: 2,
      name: r'itemName',
      type: IsarType.string,
    ),
    r'itemPrice': PropertySchema(
      id: 3,
      name: r'itemPrice',
      type: IsarType.double,
    ),
    r'status': PropertySchema(
      id: 4,
      name: r'status',
      type: IsarType.byte,
      enumMap: _DecisionLogstatusEnumValueMap,
    ),
    r'timeCostInHours': PropertySchema(
      id: 5,
      name: r'timeCostInHours',
      type: IsarType.double,
    )
  },
  estimateSize: _decisionLogEstimateSize,
  serialize: _decisionLogSerialize,
  deserialize: _decisionLogDeserialize,
  deserializeProp: _decisionLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _decisionLogGetId,
  getLinks: _decisionLogGetLinks,
  attach: _decisionLogAttach,
  version: '3.1.0+1',
);

int _decisionLogEstimateSize(
  DecisionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.itemName.length * 3;
  return bytesCount;
}

void _decisionLogSerialize(
  DecisionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeBool(offsets[1], object.isPaylater);
  writer.writeString(offsets[2], object.itemName);
  writer.writeDouble(offsets[3], object.itemPrice);
  writer.writeByte(offsets[4], object.status.index);
  writer.writeDouble(offsets[5], object.timeCostInHours);
}

DecisionLog _decisionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DecisionLog();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isPaylater = reader.readBool(offsets[1]);
  object.itemName = reader.readString(offsets[2]);
  object.itemPrice = reader.readDouble(offsets[3]);
  object.status =
      _DecisionLogstatusValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          DecisionStatus.burned;
  object.timeCostInHours = reader.readDouble(offsets[5]);
  return object;
}

P _decisionLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (_DecisionLogstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          DecisionStatus.burned) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DecisionLogstatusEnumValueMap = {
  'burned': 0,
  'saved': 1,
};
const _DecisionLogstatusValueEnumMap = {
  0: DecisionStatus.burned,
  1: DecisionStatus.saved,
};

Id _decisionLogGetId(DecisionLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _decisionLogGetLinks(DecisionLog object) {
  return [];
}

void _decisionLogAttach(
    IsarCollection<dynamic> col, Id id, DecisionLog object) {
  object.id = id;
}

extension DecisionLogQueryWhereSort
    on QueryBuilder<DecisionLog, DecisionLog, QWhere> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DecisionLogQueryWhere
    on QueryBuilder<DecisionLog, DecisionLog, QWhereClause> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idBetween(
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

extension DecisionLogQueryFilter
    on QueryBuilder<DecisionLog, DecisionLog, QFilterCondition> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      isPaylaterEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaylater',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> itemNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> itemNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> itemNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemName',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemName',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      itemPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> statusEqualTo(
      DecisionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      statusGreaterThan(
    DecisionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> statusLessThan(
    DecisionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> statusBetween(
    DecisionStatus lower,
    DecisionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      timeCostInHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeCostInHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      timeCostInHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeCostInHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      timeCostInHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeCostInHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      timeCostInHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeCostInHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension DecisionLogQueryObject
    on QueryBuilder<DecisionLog, DecisionLog, QFilterCondition> {}

extension DecisionLogQueryLinks
    on QueryBuilder<DecisionLog, DecisionLog, QFilterCondition> {}

extension DecisionLogQuerySortBy
    on QueryBuilder<DecisionLog, DecisionLog, QSortBy> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByIsPaylater() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaylater', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByIsPaylaterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaylater', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByItemPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemPrice', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByItemPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemPrice', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByTimeCostInHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeCostInHours', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      sortByTimeCostInHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeCostInHours', Sort.desc);
    });
  }
}

extension DecisionLogQuerySortThenBy
    on QueryBuilder<DecisionLog, DecisionLog, QSortThenBy> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByIsPaylater() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaylater', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByIsPaylaterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaylater', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByItemPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemPrice', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByItemPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemPrice', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByTimeCostInHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeCostInHours', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      thenByTimeCostInHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeCostInHours', Sort.desc);
    });
  }
}

extension DecisionLogQueryWhereDistinct
    on QueryBuilder<DecisionLog, DecisionLog, QDistinct> {
  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByIsPaylater() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaylater');
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByItemName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByItemPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemPrice');
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct>
      distinctByTimeCostInHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeCostInHours');
    });
  }
}

extension DecisionLogQueryProperty
    on QueryBuilder<DecisionLog, DecisionLog, QQueryProperty> {
  QueryBuilder<DecisionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DecisionLog, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DecisionLog, bool, QQueryOperations> isPaylaterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaylater');
    });
  }

  QueryBuilder<DecisionLog, String, QQueryOperations> itemNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemName');
    });
  }

  QueryBuilder<DecisionLog, double, QQueryOperations> itemPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemPrice');
    });
  }

  QueryBuilder<DecisionLog, DecisionStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DecisionLog, double, QQueryOperations>
      timeCostInHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeCostInHours');
    });
  }
}
