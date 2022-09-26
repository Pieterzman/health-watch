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


/** This is an auto generated class representing the SymptomPt type in your schema. */
@immutable
class SymptomPt extends Model {
  static const classType = const _SymptomPtModelType();
  final String id;
  final String? _healthdatauserID;
  final String? _loggedSymptom;
  final TemporalDate? _loggedDate;
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
  
  String get loggedSymptom {
    try {
      return _loggedSymptom!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDate get loggedDate {
    try {
      return _loggedDate!;
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
  
  const SymptomPt._internal({required this.id, required healthdatauserID, required loggedSymptom, required loggedDate, createdAt, updatedAt}): _healthdatauserID = healthdatauserID, _loggedSymptom = loggedSymptom, _loggedDate = loggedDate, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SymptomPt({String? id, required String healthdatauserID, required String loggedSymptom, required TemporalDate loggedDate}) {
    return SymptomPt._internal(
      id: id == null ? UUID.getUUID() : id,
      healthdatauserID: healthdatauserID,
      loggedSymptom: loggedSymptom,
      loggedDate: loggedDate);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SymptomPt &&
      id == other.id &&
      _healthdatauserID == other._healthdatauserID &&
      _loggedSymptom == other._loggedSymptom &&
      _loggedDate == other._loggedDate;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SymptomPt {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("healthdatauserID=" + "$_healthdatauserID" + ", ");
    buffer.write("loggedSymptom=" + "$_loggedSymptom" + ", ");
    buffer.write("loggedDate=" + (_loggedDate != null ? _loggedDate!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SymptomPt copyWith({String? id, String? healthdatauserID, String? loggedSymptom, TemporalDate? loggedDate}) {
    return SymptomPt._internal(
      id: id ?? this.id,
      healthdatauserID: healthdatauserID ?? this.healthdatauserID,
      loggedSymptom: loggedSymptom ?? this.loggedSymptom,
      loggedDate: loggedDate ?? this.loggedDate);
  }
  
  SymptomPt.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _healthdatauserID = json['healthdatauserID'],
      _loggedSymptom = json['loggedSymptom'],
      _loggedDate = json['loggedDate'] != null ? TemporalDate.fromString(json['loggedDate']) : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'healthdatauserID': _healthdatauserID, 'loggedSymptom': _loggedSymptom, 'loggedDate': _loggedDate?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "symptomPt.id");
  static final QueryField HEALTHDATAUSERID = QueryField(fieldName: "healthdatauserID");
  static final QueryField LOGGEDSYMPTOM = QueryField(fieldName: "loggedSymptom");
  static final QueryField LOGGEDDATE = QueryField(fieldName: "loggedDate");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SymptomPt";
    modelSchemaDefinition.pluralName = "SymptomPts";
    
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
      key: SymptomPt.HEALTHDATAUSERID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SymptomPt.LOGGEDSYMPTOM,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SymptomPt.LOGGEDDATE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.date)
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

class _SymptomPtModelType extends ModelType<SymptomPt> {
  const _SymptomPtModelType();
  
  @override
  SymptomPt fromJson(Map<String, dynamic> jsonData) {
    return SymptomPt.fromJson(jsonData);
  }
}