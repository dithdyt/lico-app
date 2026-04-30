// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_valuation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserValuationCollection on Isar {
  IsarCollection<UserValuation> get userValuations => this.collection();
}

const UserValuationSchema = CollectionSchema(
  name: r'UserValuation',
  id: -6838442265628423895,
  properties: {
    r'hourlyRate': PropertySchema(
      id: 0,
      name: r'hourlyRate',
      type: IsarType.double,
    ),
    r'monthlyIncome': PropertySchema(
      id: 1,
      name: r'monthlyIncome',
      type: IsarType.double,
    ),
    r'monthlyWorkHours': PropertySchema(
      id: 2,
      name: r'monthlyWorkHours',
      type: IsarType.double,
    ),
    r'weeklyWorkHours': PropertySchema(
      id: 3,
      name: r'weeklyWorkHours',
      type: IsarType.double,
    )
  },
  estimateSize: _userValuationEstimateSize,
  serialize: _userValuationSerialize,
  deserialize: _userValuationDeserialize,
  deserializeProp: _userValuationDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userValuationGetId,
  getLinks: _userValuationGetLinks,
  attach: _userValuationAttach,
  version: '3.1.0+1',
);

int _userValuationEstimateSize(
  UserValuation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _userValuationSerialize(
  UserValuation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.hourlyRate);
  writer.writeDouble(offsets[1], object.monthlyIncome);
  writer.writeDouble(offsets[2], object.monthlyWorkHours);
  writer.writeDouble(offsets[3], object.weeklyWorkHours);
}

UserValuation _userValuationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserValuation();
  object.id = id;
  object.monthlyIncome = reader.readDouble(offsets[1]);
  object.weeklyWorkHours = reader.readDouble(offsets[3]);
  return object;
}

P _userValuationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userValuationGetId(UserValuation object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userValuationGetLinks(UserValuation object) {
  return [];
}

void _userValuationAttach(
    IsarCollection<dynamic> col, Id id, UserValuation object) {
  object.id = id;
}

extension UserValuationQueryWhereSort
    on QueryBuilder<UserValuation, UserValuation, QWhere> {
  QueryBuilder<UserValuation, UserValuation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserValuationQueryWhere
    on QueryBuilder<UserValuation, UserValuation, QWhereClause> {
  QueryBuilder<UserValuation, UserValuation, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<UserValuation, UserValuation, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterWhereClause> idBetween(
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

extension UserValuationQueryFilter
    on QueryBuilder<UserValuation, UserValuation, QFilterCondition> {
  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      hourlyRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hourlyRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      hourlyRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hourlyRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      hourlyRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hourlyRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      hourlyRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hourlyRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
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

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyIncomeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyIncome',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyIncomeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyIncome',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyIncomeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyIncome',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyIncomeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyIncome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyWorkHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyWorkHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyWorkHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyWorkHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyWorkHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyWorkHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      monthlyWorkHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyWorkHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      weeklyWorkHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyWorkHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      weeklyWorkHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyWorkHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      weeklyWorkHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyWorkHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterFilterCondition>
      weeklyWorkHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyWorkHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension UserValuationQueryObject
    on QueryBuilder<UserValuation, UserValuation, QFilterCondition> {}

extension UserValuationQueryLinks
    on QueryBuilder<UserValuation, UserValuation, QFilterCondition> {}

extension UserValuationQuerySortBy
    on QueryBuilder<UserValuation, UserValuation, QSortBy> {
  QueryBuilder<UserValuation, UserValuation, QAfterSortBy> sortByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      sortByHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.desc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      sortByMonthlyIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncome', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      sortByMonthlyIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncome', Sort.desc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      sortByMonthlyWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWorkHours', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      sortByMonthlyWorkHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWorkHours', Sort.desc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      sortByWeeklyWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyWorkHours', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      sortByWeeklyWorkHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyWorkHours', Sort.desc);
    });
  }
}

extension UserValuationQuerySortThenBy
    on QueryBuilder<UserValuation, UserValuation, QSortThenBy> {
  QueryBuilder<UserValuation, UserValuation, QAfterSortBy> thenByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      thenByHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.desc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      thenByMonthlyIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncome', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      thenByMonthlyIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyIncome', Sort.desc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      thenByMonthlyWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWorkHours', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      thenByMonthlyWorkHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyWorkHours', Sort.desc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      thenByWeeklyWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyWorkHours', Sort.asc);
    });
  }

  QueryBuilder<UserValuation, UserValuation, QAfterSortBy>
      thenByWeeklyWorkHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyWorkHours', Sort.desc);
    });
  }
}

extension UserValuationQueryWhereDistinct
    on QueryBuilder<UserValuation, UserValuation, QDistinct> {
  QueryBuilder<UserValuation, UserValuation, QDistinct> distinctByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourlyRate');
    });
  }

  QueryBuilder<UserValuation, UserValuation, QDistinct>
      distinctByMonthlyIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyIncome');
    });
  }

  QueryBuilder<UserValuation, UserValuation, QDistinct>
      distinctByMonthlyWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyWorkHours');
    });
  }

  QueryBuilder<UserValuation, UserValuation, QDistinct>
      distinctByWeeklyWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyWorkHours');
    });
  }
}

extension UserValuationQueryProperty
    on QueryBuilder<UserValuation, UserValuation, QQueryProperty> {
  QueryBuilder<UserValuation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserValuation, double, QQueryOperations> hourlyRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourlyRate');
    });
  }

  QueryBuilder<UserValuation, double, QQueryOperations>
      monthlyIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyIncome');
    });
  }

  QueryBuilder<UserValuation, double, QQueryOperations>
      monthlyWorkHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyWorkHours');
    });
  }

  QueryBuilder<UserValuation, double, QQueryOperations>
      weeklyWorkHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyWorkHours');
    });
  }
}
