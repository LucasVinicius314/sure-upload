import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class User {
  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.bucket,
    required this.key,
  });

  int? id;
  String? createdAt;
  String? updatedAt;
  String? bucket;
  String? key;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
