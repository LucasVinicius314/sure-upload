// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_files_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListFilesResponse _$ListFilesResponseFromJson(Map<String, dynamic> json) =>
    ListFilesResponse(
      files:
          (json['files'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ListFilesResponseToJson(ListFilesResponse instance) =>
    <String, dynamic>{
      'files': instance.files,
    };
