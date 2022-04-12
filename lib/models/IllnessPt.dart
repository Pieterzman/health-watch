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


/** This is an auto generated class representing the IllnessPt type in your schema. */
@immutable
class IllnessPt extends Model {
  static const classType = const _IllnessPtModelType();
  final String id;
  final String? _healthdatauserID;
  final String? _loggedIllness;
  final String? _loggedIllnessDiagnosis;
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
  
  String get loggedIllness {
    try {
      return _loggedIllness!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get loggedIllnessDiagnosis {
    try {
      return _loggedIllnessDiagnosis!;
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
  
  const IllnessPt._internal({required this.id, required healthdatauserID, required loggedIllness, required loggedIllnessDiagnosis, required loggedDate, createdAt, updatedAt}): _healthdatauserID = healthdatauserID, _loggedIllness = loggedIllness, _loggedIllnessDiagnosis = loggedIllnessDiagnosis, _loggedDate = loggedDate, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory IllnessPt({String? id, required String healthdatauserID, required String loggedIllness, required String loggedIllnessDiagnosis, required TemporalDate loggedDate}) {
    return IllnessPt._internal(
      id: id == null ? UUID.getUUID() : id,
      healthdatauserID: healthdatauserID,
      loggedIllness: loggedIllness,
      loggedIllnessDiagnosis: loggedIllnessDiagnosis,
      loggedDate: loggedDate);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IllnessPt &&
      id == other.id &&
      _healthdatauserID == other._healthdatauserID &&
      _loggedIllness == other._loggedIllness &&
      _loggedIllnessDiagnosis == other._loggedIllnessDiagnosis &&
      _loggedDate == other._loggedDate;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("IllnessPt {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("healthdatauserID=" + "$_healthdatauserID" + ", ");
    buffer.write("loggedIllness=" + "$_loggedIllness" + ", ");
    buffer.write("loggedIllnessDiagnosis=" + "$_loggedIllnessDiagnosis" + ", ");
    buffer.write("loggedDate=" + (_loggedDate != null ? _loggedDate!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  IllnessPt copyWith({String? id, String? healthdatauserID, String? loggedIllness, String? loggedIllnessDiagnosis, TemporalDate? loggedDate}) {
    return IllnessPt._internal(
      id: id ?? this.id,
      healthdatauserID: healthdatauserID ?? this.healthdatauserID,
      loggedIllness: loggedIllness ?? this.loggedIllness,
      loggedIllnessDiagnosis: loggedIllnessDiagnosis ?? this.loggedIllnessDiagnosis,
      loggedDate: loggedDate ?? this.loggedDate);
  }
  
  IllnessPt.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _healthdatauserID = json['healthdatauserID'],
      _loggedIllness = json['loggedIllness'],
      _loggedIllnessDiagnosis = json['loggedIllnessDiagnosis'],
      _loggedDate = json['loggedDate'] != null ? TemporalDate.fromString(json['loggedDate']) : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'healthdatauserID': _healthdatauserID, 'loggedIllness': _loggedIllness, 'loggedIllnessDiagnosis': _loggedIllnessDiagnosis, 'loggedDate': _loggedDate?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "illnessPt.id");
  static final QueryField HEALTHDATAUSERID = QueryField(fieldName: "healthdatauserID");
  static final QueryField LOGGEDILLNESS = QueryField(fieldName: "loggedIllness");
  static final QueryField LOGGEDILLNESSDIAGNOSIS = QueryField(fieldName: "loggedIllnessDiagnosis");
  static final QueryField LOGGEDDATE = QueryField(fieldName: "loggedDate");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "IllnessPt";
    modelSchemaDefinition.pluralName = "IllnessPts";
    
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
      key: IllnessPt.HEALTHDATAUSERID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: IllnessPt.LOGGEDILLNESS,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: IllnessPt.LOGGEDILLNESSDIAGNOSIS,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: IllnessPt.LOGGEDDATE,
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

class _IllnessPtModelType extends ModelType<IllnessPt> {
  const _IllnessPtModelType();
  
  @override
  IllnessPt fromJson(Map<String, dynamic> jsonData) {
    return IllnessPt.fromJson(jsonData);
  }
}