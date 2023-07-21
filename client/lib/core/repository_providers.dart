import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sure_upload/interceptors/auth_interceptor.dart';
import 'package:sure_upload/repositories/file_repository.dart';
import 'package:sure_upload/repositories/local_repository.dart';
import 'package:sure_upload/repositories/user_repository.dart';
import 'package:sure_upload/utils/api.dart';
import 'package:sure_upload/utils/env.dart';

class RepositoryProviders extends StatelessWidget {
  const RepositoryProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final localRepository = LocalRepository();

    final api = Api(
      authority: Env.apiAuthority,
      localRepository: localRepository,
      client: InterceptedClient.build(
        interceptors: [AuthInterceptor(localRepository: localRepository)],
      ),
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => FileRepository(api: api)),
        RepositoryProvider(create: (context) => localRepository),
        RepositoryProvider(create: (context) => UserRepository(api: api)),
      ],
      child: child,
    );
  }
}
