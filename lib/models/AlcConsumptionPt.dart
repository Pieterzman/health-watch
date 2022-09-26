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


/** This is an auto generated class representing the AlcConsumptionPt type in your schema. */
@immutable
class AlcConsumptionPt extends Model {
  static const classType = const _AlcConsumptionPtModelType();
  final String id;
  final String? _healthdatauserID;
  final String? _loggedAlcConsumptionPt;
  final double? _loggedUnitsConsumed;
  final TemporalDateTime? _loggedDateTime;
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
  
  String get loggedAlcConsumptionPt {
    try {
      return _loggedAlcConsumptionPt!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get loggedUnitsConsumed {
    return _loggedUnitsConsumed;
  }
  
  TemporalDateTime? get loggedDateTime {
    return _loggedDateTime;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const AlcConsumptionPt._internal({required this.id, required healthdatauserID, required loggedAlcConsumptionPt, loggedUnitsConsumed, loggedDateTime, createdAt, updatedAt}): _healthdatauserID = healthdatauserID, _loggedAlcConsumptionPt = loggedAlcConsumptionPt, _loggedUnitsConsumed = loggedUnitsConsumed, _loggedDateTime = loggedDateTime, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory AlcConsumptionPt({String? id, required String healthdatauserID, required String loggedAlcConsumptionPt, double? loggedUnitsConsumed, TemporalDateTime? loggedDateTime}) {
    return AlcConsumptionPt._internal(
      id: id == null ? UUID.getUUID() : id,
      healthdatauserID: healthdatauserID,
      loggedAlcConsumptionPt: loggedAlcConsumptionPt,
      loggedUnitsConsumed: loggedUnitsConsumed,
      loggedDateTime: loggedDateTime);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AlcConsumptionPt &&
      id == other.id &&
      _healthdatauserID == other._healthdatauserID &&
      _loggedAlcConsumptionPt == other._loggedAlcConsumptionPt &&
      _loggedUnitsConsumed == other._loggedUnitsConsumed &&
      _loggedDateTime == other._loggedDateTime;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AlcConsumptionPt {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("healthdatauserID=" + "$_healthdatauserID" + ", ");
    buffer.write("loggedAlcConsumptionPt=" + "$_loggedAlcConsumptionPt" + ", ");
    buffer.write("loggedUnitsConsumed=" + (_loggedUnitsConsumed != null ? _loggedUnitsConsumed!.toString() : "null") + ", ");
    buffer.write("loggedDateTime=" + (_loggedDateTime != null ? _loggedDateTime!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AlcConsumptionPt copyWith({String? id, String? healthdatauserID, String? loggedAlcConsumptionPt, double? loggedUnitsConsumed, TemporalDateTime? loggedDateTime}) {
    return AlcConsumptionPt._internal(
      id: id ?? this.id,
      healthdatauserID: healthdatauserID ?? this.healthdatauserID,
      loggedAlcConsumptionPt: loggedAlcConsumptionPt ?? this.loggedAlcConsumptionPt,
      loggedUnitsConsumed: loggedUnitsConsumed ?? this.loggedUnitsConsumed,
      loggedDateTime: loggedDateTime ?? this.loggedDateTime);
  }
  
  AlcConsumptionPt.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _healthdatauserID = json['healthdatauserID'],
      _loggedAlcConsumptionPt = json['loggedAlcConsumptionPt'],
      _loggedUnitsConsumed = (json['loggedUnitsConsumed'] as num?)?.toDouble(),
      _loggedDateTime = json['loggedDateTime'] != null ? TemporalDateTime.fromString(json['loggedDateTime']) : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'healthdatauserID': _healthdatauserID, 'loggedAlcConsumptionPt': _loggedAlcConsumptionPt, 'loggedUnitsConsumed': _loggedUnitsConsumed, 'loggedDateTime': _loggedDateTime?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "alcConsumptionPt.id");
  static final QueryField HEALTHDATAUSERID = QueryField(fieldName: "healthdatauserID");
  static final QueryField LOGGEDALCCONSUMPTIONPT = QueryField(fieldName: "loggedAlcConsumptionPt");
  static final QueryField LOGGEDUNITSCONSUMED = QueryField(fieldName: "loggedUnitsConsumed");
  static final QueryField LOGGEDDATETIME = QueryField(fieldName: "loggedDateTime");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AlcConsumptionPt";
    modelSchemaDefinition.pluralName = "AlcConsumptionPts";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AlcConsumptionPt.HEALTHDATAUSERID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AlcConsumptionPt.LOGGEDALCCONSUMPTIONPT,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AlcConsumptionPt.LOGGEDUNITSCONSUMED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AlcConsumptionPt.LOGGEDDATETIME,
      isRequired: false,
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

class _AlcConsumptionPtModelType extends ModelType<AlcConsumptionPt> {
  const _AlcConsumptionPtModelType();
  
  @override
  AlcConsumptionPt fromJson(Map<String, dynamic> jsonData) {
    return AlcConsumptionPt.fromJson(jsonData);
  }
}