/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the HealthDataUser type in your schema. */
@immutable
class HealthDataUser extends Model {
  static const classType = const _HealthDataUserModelType();
  final String id;
  final String? _useruuID;
  final String? _age;
  final String? _weight;
  final String? _height;
  final String? _sex;
  final String? _smartwatch;
  final bool? _opt_out;
  final TemporalDateTime? _signedUp;
  final TemporalDateTime? _lastSignedIn;
  final TemporalDateTime? _lastRefreshed;
  final List<HealthDataPt>? _healthDataPts;
  final List<SymptomPt>? _symptomPts;
  final List<IllnessPt>? _IllnessPts;
  final List<AlcConsumptionPt>? _AlcConsumptionPts;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get useruuID {
    try {
      return _useruuID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get age {
    return _age;
  }
  
  String? get weight {
    return _weight;
  }
  
  String? get height {
    return _height;
  }
  
  String? get sex {
    return _sex;
  }
  
  String? get smartwatch {
    return _smartwatch;
  }
  
  bool get opt_out {
    try {
      return _opt_out!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get signedUp {
    try {
      return _signedUp!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get lastSignedIn {
    try {
      return _lastSignedIn!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get lastRefreshed {
    try {
      return _lastRefreshed!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<HealthDataPt>? get healthDataPts {
    return _healthDataPts;
  }
  
  List<SymptomPt>? get symptomPts {
    return _symptomPts;
  }
  
  List<IllnessPt>? get IllnessPts {
    return _IllnessPts;
  }
  
  List<AlcConsumptionPt>? get AlcConsumptionPts {
    return _AlcConsumptionPts;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const HealthDataUser._internal({required this.id, required useruuID, age, weight, height, sex, smartwatch, required opt_out, required signedUp, required lastSignedIn, required lastRefreshed, healthDataPts, symptomPts, IllnessPts, AlcConsumptionPts, createdAt, updatedAt}): _useruuID = useruuID, _age = age, _weight = weight, _height = height, _sex = sex, _smartwatch = smartwatch, _opt_out = opt_out, _signedUp = signedUp, _lastSignedIn = lastSignedIn, _lastRefreshed = lastRefreshed, _healthDataPts = healthDataPts, _symptomPts = symptomPts, _IllnessPts = IllnessPts, _AlcConsumptionPts = AlcConsumptionPts, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory HealthDataUser({String? id, required String useruuID, String? age, String? weight, String? height, String? sex, String? smartwatch, required bool opt_out, required TemporalDateTime signedUp, required TemporalDateTime lastSignedIn, required TemporalDateTime lastRefreshed, List<HealthDataPt>? healthDataPts, List<SymptomPt>? symptomPts, List<IllnessPt>? IllnessPts, List<AlcConsumptionPt>? AlcConsumptionPts}) {
    return HealthDataUser._internal(
      id: id == null ? UUID.getUUID() : id,
      useruuID: useruuID,
      age: age,
      weight: weight,
      height: height,
      sex: sex,
      smartwatch: smartwatch,
      opt_out: opt_out,
      signedUp: signedUp,
      lastSignedIn: lastSignedIn,
      lastRefreshed: lastRefreshed,
      healthDataPts: healthDataPts != null ? List<HealthDataPt>.unmodifiable(healthDataPts) : healthDataPts,
      symptomPts: symptomPts != null ? List<SymptomPt>.unmodifiable(symptomPts) : symptomPts,
      IllnessPts: IllnessPts != null ? List<IllnessPt>.unmodifiable(IllnessPts) : IllnessPts,
      AlcConsumptionPts: AlcConsumptionPts != null ? List<AlcConsumptionPt>.unmodifiable(AlcConsumptionPts) : AlcConsumptionPts);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthDataUser &&
      id == other.id &&
      _useruuID == other._useruuID &&
      _age == other._age &&
      _weight == other._weight &&
      _height == other._height &&
      _sex == other._sex &&
      _smartwatch == other._smartwatch &&
      _opt_out == other._opt_out &&
      _signedUp == other._signedUp &&
      _lastSignedIn == other._lastSignedIn &&
      _lastRefreshed == other._lastRefreshed &&
      DeepCollectionEquality().equals(_healthDataPts, other._healthDataPts) &&
      DeepCollectionEquality().equals(_symptomPts, other._symptomPts) &&
      DeepCollectionEquality().equals(_IllnessPts, other._IllnessPts) &&
      DeepCollectionEquality().equals(_AlcConsumptionPts, other._AlcConsumptionPts);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("HealthDataUser {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("useruuID=" + "$_useruuID" + ", ");
    buffer.write("age=" + "$_age" + ", ");
    buffer.write("weight=" + "$_weight" + ", ");
    buffer.write("height=" + "$_height" + ", ");
    buffer.write("sex=" + "$_sex" + ", ");
    buffer.write("smartwatch=" + "$_smartwatch" + ", ");
    buffer.write("opt_out=" + (_opt_out != null ? _opt_out!.toString() : "null") + ", ");
    buffer.write("signedUp=" + (_signedUp != null ? _signedUp!.format() : "null") + ", ");
    buffer.write("lastSignedIn=" + (_lastSignedIn != null ? _lastSignedIn!.format() : "null") + ", ");
    buffer.write("lastRefreshed=" + (_lastRefreshed != null ? _lastRefreshed!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  HealthDataUser copyWith({String? id, String? useruuID, String? age, String? weight, String? height, String? sex, String? smartwatch, bool? opt_out, TemporalDateTime? signedUp, TemporalDateTime? lastSignedIn, TemporalDateTime? lastRefreshed, List<HealthDataPt>? healthDataPts, List<SymptomPt>? symptomPts, List<IllnessPt>? IllnessPts, List<AlcConsumptionPt>? AlcConsumptionPts}) {
    return HealthDataUser._internal(
      id: id ?? this.id,
      useruuID: useruuID ?? this.useruuID,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      sex: sex ?? this.sex,
      smartwatch: smartwatch ?? this.smartwatch,
      opt_out: opt_out ?? this.opt_out,
      signedUp: signedUp ?? this.signedUp,
      lastSignedIn: lastSignedIn ?? this.lastSignedIn,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
      healthDataPts: healthDataPts ?? this.healthDataPts,
      symptomPts: symptomPts ?? this.symptomPts,
      IllnessPts: IllnessPts ?? this.IllnessPts,
      AlcConsumptionPts: AlcConsumptionPts ?? this.AlcConsumptionPts);
  }
  
  HealthDataUser.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _useruuID = json['useruuID'],
      _age = json['age'],
      _weight = json['weight'],
      _height = json['height'],
      _sex = json['sex'],
      _smartwatch = json['smartwatch'],
      _opt_out = json['opt_out'],
      _signedUp = json['signedUp'] != null ? TemporalDateTime.fromString(json['signedUp']) : null,
      _lastSignedIn = json['lastSignedIn'] != null ? TemporalDateTime.fromString(json['lastSignedIn']) : null,
      _lastRefreshed = json['lastRefreshed'] != null ? TemporalDateTime.fromString(json['lastRefreshed']) : null,
      _healthDataPts = json['healthDataPts'] is List
        ? (json['healthDataPts'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => HealthDataPt.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _symptomPts = json['symptomPts'] is List
        ? (json['symptomPts'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => SymptomPt.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _IllnessPts = json['IllnessPts'] is List
        ? (json['IllnessPts'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => IllnessPt.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _AlcConsumptionPts = json['AlcConsumptionPts'] is List
        ? (json['AlcConsumptionPts'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => AlcConsumptionPt.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'useruuID': _useruuID, 'age': _age, 'weight': _weight, 'height': _height, 'sex': _sex, 'smartwatch': _smartwatch, 'opt_out': _opt_out, 'signedUp': _signedUp?.format(), 'lastSignedIn': _lastSignedIn?.format(), 'lastRefreshed': _lastRefreshed?.format(), 'healthDataPts': _healthDataPts?.map((HealthDataPt? e) => e?.toJson()).toList(), 'symptomPts': _symptomPts?.map((SymptomPt? e) => e?.toJson()).toList(), 'IllnessPts': _IllnessPts?.map((IllnessPt? e) => e?.toJson()).toList(), 'AlcConsumptionPts': _AlcConsumptionPts?.map((AlcConsumptionPt? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "healthDataUser.id");
  static final QueryField USERUUID = QueryField(fieldName: "useruuID");
  static final QueryField AGE = QueryField(fieldName: "age");
  static final QueryField WEIGHT = QueryField(fieldName: "weight");
  static final QueryField HEIGHT = QueryField(fieldName: "height");
  static final QueryField SEX = QueryField(fieldName: "sex");
  static final QueryField SMARTWATCH = QueryField(fieldName: "smartwatch");
  static final QueryField OPT_OUT = QueryField(fieldName: "opt_out");
  static final QueryField SIGNEDUP = QueryField(fieldName: "signedUp");
  static final QueryField LASTSIGNEDIN = QueryField(fieldName: "lastSignedIn");
  static final QueryField LASTREFRESHED = QueryField(fieldName: "lastRefreshed");
  static final QueryField HEALTHDATAPTS = QueryField(
    fieldName: "healthDataPts",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (HealthDataPt).toString()));
  static final QueryField SYMPTOMPTS = QueryField(
    fieldName: "symptomPts",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (SymptomPt).toString()));
  static final QueryField ILLNESSPTS = QueryField(
    fieldName: "IllnessPts",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (IllnessPt).toString()));
  static final QueryField ALCCONSUMPTIONPTS = QueryField(
    fieldName: "AlcConsumptionPts",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: (AlcConsumptionPt).toString()));
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "HealthDataUser";
    modelSchemaDefinition.pluralName = "HealthDataUsers";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.USERUUID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.AGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.WEIGHT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.HEIGHT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.SEX,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.SMARTWATCH,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.OPT_OUT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.SIGNEDUP,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.LASTSIGNEDIN,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataUser.LASTREFRESHED,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: HealthDataUser.HEALTHDATAPTS,
      isRequired: false,
      ofModelName: (HealthDataPt).toString(),
      associatedKey: HealthDataPt.HEALTHDATAUSERID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: HealthDataUser.SYMPTOMPTS,
      isRequired: false,
      ofModelName: (SymptomPt).toString(),
      associatedKey: SymptomPt.HEALTHDATAUSERID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: HealthDataUser.ILLNESSPTS,
      isRequired: false,
      ofModelName: (IllnessPt).toString(),
      associatedKey: IllnessPt.HEALTHDATAUSERID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: HealthDataUser.ALCCONSUMPTIONPTS,
      isRequired: false,
      ofModelName: (AlcConsumptionPt).toString(),
      associatedKey: AlcConsumptionPt.HEALTHDATAUSERID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _HealthDataUserModelType extends ModelType<HealthDataUser> {
  const _HealthDataUserModelType();
  
  @override
  HealthDataUser fromJson(Map<String, dynamic> jsonData) {
    return HealthDataUser.fromJson(jsonData);
  }
}