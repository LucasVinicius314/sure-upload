import 'package:cross_file/cross_file.dart';
import 'package:sure_upload/models/responses/list_files_response.dart';
import 'package:sure_upload/utils/api.dart';

class FileRepository {
  const FileRepository({
    required this.api,
  });

  final Api api;

  Future<void> create({
    required XFile file,
  }) async {
    await api.postForm(
      path: 'api/v1/file/',
      files: {
        'upload': file,
      },
    );
  }

  Future<void> delete({
    required String fileName,
  }) async {
    await api.delete(
      path: 'api/v1/file/$fileName',
      body: {},
    );
  }

  Future<ListFilesResponse> list() async {
    final res = await api.get(
      path: 'api/v1/file/',
    );

    return ListFilesResponse.fromJson(res);
  }
}
