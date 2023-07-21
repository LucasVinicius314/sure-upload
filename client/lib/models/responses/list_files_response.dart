import 'package:json_annotation/json_annotation.dart';

part 'list_files_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class ListFilesResponse {
  ListFilesResponse({
    required this.files,
  });

  final List<String>? files;

  factory ListFilesResponse.fromJson(Map<String, dynamic> json) =>
      _$ListFilesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListFilesResponseToJson(this);
}
