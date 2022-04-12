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

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the HealthDataPt type in your schema. */
@immutable
class HealthDataPt extends Model {
  static const classType = const _HealthDataPtModelType();
  final String id;
  final String? _healthdatauserID;
  final String? _typeString;
  final double? _value;
  final String? _unitString;
  final String? _sourceID;
  final TemporalDateTime? _dateFrom;
  final TemporalDateTime? _dateTo;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get healthdatauserID {
    try {
      return _healthdatauserID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get typeString {
    try {
      return _typeString!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get value {
    try {
      return _value!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get unitString {
    try {
      return _unitString!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get sourceID {
    try {
      return _sourceID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get dateFrom {
    try {
      return _dateFrom!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get dateTo {
    try {
      return _dateTo!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const HealthDataPt._internal({required this.id, required healthdatauserID, required typeString, required value, required unitString, required sourceID, required dateFrom, required dateTo, createdAt, updatedAt}): _healthdatauserID = healthdatauserID, _typeString = typeString, _value = value, _unitString = unitString, _sourceID = sourceID, _dateFrom = dateFrom, _dateTo = dateTo, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory HealthDataPt({String? id, required String healthdatauserID, required String typeString, required double value, required String unitString, required String sourceID, required TemporalDateTime dateFrom, required TemporalDateTime dateTo}) {
    return HealthDataPt._internal(
      id: id == null ? UUID.getUUID() : id,
      healthdatauserID: healthdatauserID,
      typeString: typeString,
      value: value,
      unitString: unitString,
      sourceID: sourceID,
      dateFrom: dateFrom,
      dateTo: dateTo);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthDataPt &&
      id == other.id &&
      _healthdatauserID == other._healthdatauserID &&
      _typeString == other._typeString &&
      _value == other._value &&
      _unitString == other._unitString &&
      _sourceID == other._sourceID &&
      _dateFrom == other._dateFrom &&
      _dateTo == other._dateTo;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("HealthDataPt {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("healthdatauserID=" + "$_healthdatauserID" + ", ");
    buffer.write("typeString=" + "$_typeString" + ", ");
    buffer.write("value=" + (_value != null ? _value!.toString() : "null") + ", ");
    buffer.write("unitString=" + "$_unitString" + ", ");
    buffer.write("sourceID=" + "$_sourceID" + ", ");
    buffer.write("dateFrom=" + (_dateFrom != null ? _dateFrom!.format() : "null") + ", ");
    buffer.write("dateTo=" + (_dateTo != null ? _dateTo!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  HealthDataPt copyWith({String? id, String? healthdatauserID, String? typeString, double? value, String? unitString, String? sourceID, TemporalDateTime? dateFrom, TemporalDateTime? dateTo}) {
    return HealthDataPt._internal(
      id: id ?? this.id,
      healthdatauserID: healthdatauserID ?? this.healthdatauserID,
      typeString: typeString ?? this.typeString,
      value: value ?? this.value,
      unitString: unitString ?? this.unitString,
      sourceID: sourceID ?? this.sourceID,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo);
  }
  
  HealthDataPt.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _healthdatauserID = json['healthdatauserID'],
      _typeString = json['typeString'],
      _value = (json['value'] as num?)?.toDouble(),
      _unitString = json['unitString'],
      _sourceID = json['sourceID'],
      _dateFrom = json['dateFrom'] != null ? TemporalDateTime.fromString(json['dateFrom']) : null,
      _dateTo = json['dateTo'] != null ? TemporalDateTime.fromString(json['dateTo']) : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'healthdatauserID': _healthdatauserID, 'typeString': _typeString, 'value': _value, 'unitString': _unitString, 'sourceID': _sourceID, 'dateFrom': _dateFrom?.format(), 'dateTo': _dateTo?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "healthDataPt.id");
  static final QueryField HEALTHDATAUSERID = QueryField(fieldName: "healthdatauserID");
  static final QueryField TYPESTRING = QueryField(fieldName: "typeString");
  static final QueryField VALUE = QueryField(fieldName: "value");
  static final QueryField UNITSTRING = QueryField(fieldName: "unitString");
  static final QueryField SOURCEID = QueryField(fieldName: "sourceID");
  static final QueryField DATEFROM = QueryField(fieldName: "dateFrom");
  static final QueryField DATETO = QueryField(fieldName: "dateTo");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "HealthDataPt";
    modelSchemaDefinition.pluralName = "HealthDataPts";
    
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
      key: HealthDataPt.HEALTHDATAUSERID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataPt.TYPESTRING,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataPt.VALUE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataPt.UNITSTRING,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataPt.SOURCEID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataPt.DATEFROM,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: HealthDataPt.DATETO,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
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

class _HealthDataPtModelType extends ModelType<HealthDataPt> {
  const _HealthDataPtModelType();
  
  @override
  HealthDataPt fromJson(Map<String, dynamic> jsonData) {
    return HealthDataPt.fromJson(jsonData);
  }
}