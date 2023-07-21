import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sure_upload/blocs/file_bloc.dart';
import 'package:sure_upload/blocs/user_bloc.dart';
import 'package:sure_upload/repositories/file_repository.dart';
import 'package:sure_upload/repositories/local_repository.dart';
import 'package:sure_upload/repositories/user_repository.dart';

class BlocProviders extends StatelessWidget {
  const BlocProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fileRepository = RepositoryProvider.of<FileRepository>(context);
    final localRepository = RepositoryProvider.of<LocalRepository>(context);
    final userRepository = RepositoryProvider.of<UserRepository>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FileBloc(
            fileRepository: fileRepository,
          ),
        ),
        BlocProvider(
          create: (context) => UserBloc(
            localRepository: localRepository,
            userRepository: userRepository,
          ),
        ),
      ],
      child: child,
    );
  }
}
