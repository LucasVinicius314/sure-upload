import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final api = Api(authority: Env.apiAuthority);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => LocalRepository()),
        RepositoryProvider(create: (context) => UserRepository(api: api)),
      ],
      child: child,
    );
  }
}
