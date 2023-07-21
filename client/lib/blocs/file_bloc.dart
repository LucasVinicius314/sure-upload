import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sure_upload/repositories/file_repository.dart';

abstract class FileEvent {}

class CreateFileEvent extends FileEvent {
  CreateFileEvent({
    required this.file,
  });

  final XFile file;
}

class DeleteFileEvent extends FileEvent {
  DeleteFileEvent({
    required this.fileName,
  });

  final String fileName;
}

class ListFilesEvent extends FileEvent {}

abstract class FileState {}

class InitialFileState extends FileState {}

class CreateFileLoadingState extends FileState {}

class CreateFileDoneState extends FileState {}

class CreateFileErrorState extends FileState {}

class DeleteFileLoadingState extends FileState {}

class DeleteFileDoneState extends FileState {}

class DeleteFileErrorState extends FileState {}

class ListFilesLoadingState extends FileState {}

class ListFilesDoneState extends FileState {
  ListFilesDoneState({
    required this.files,
  });

  final List<String> files;
}

class ListFilesErrorState extends FileState {}

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc({
    required this.fileRepository,
  }) : super(InitialFileState()) {
    on<CreateFileEvent>((event, emit) async {
      try {
        emit(CreateFileLoadingState());

        await fileRepository.create(file: event.file);

        emit(CreateFileDoneState());
      } catch (e) {
        emit(CreateFileErrorState());
      }
    });

    on<ListFilesEvent>((event, emit) async {
      try {
        emit(ListFilesLoadingState());

        final listFilesRes = await fileRepository.list();

        emit(ListFilesDoneState(files: listFilesRes.files ?? []));
      } catch (e) {
        emit(ListFilesErrorState());
      }
    });

    on<DeleteFileEvent>((event, emit) async {
      try {
        emit(DeleteFileLoadingState());

        await fileRepository.delete(fileName: event.fileName);

        emit(DeleteFileDoneState());
      } catch (e) {
        emit(DeleteFileErrorState());
      }
    });
  }

  final FileRepository fileRepository;
}
