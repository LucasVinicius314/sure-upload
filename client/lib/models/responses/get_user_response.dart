import 'package:json_annotation/json_annotation.dart';
import 'package:sure_upload/models/user.dart';

part 'get_user_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class GetUserResponse {
  const GetUserResponse({
    required this.user,
  });

  final User? user;

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserResponseToJson(this);
}
