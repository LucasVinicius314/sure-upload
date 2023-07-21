import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sure_upload/blocs/user_bloc.dart';
import 'package:sure_upload/screens/login_page.dart';
import 'package:sure_upload/utils/constants.dart';
import 'package:sure_upload/utils/utils.dart';

class BasePageLayout extends StatelessWidget {
  const BasePageLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (ModalRoute.of(context)?.isFirst != true) {
          return;
        }

        if (state is LogoutDoneState) {
          Utils.replaceAllRoutes(context, LoginPage.route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Constants.appName),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Divider(height: 0),
          ),
        ),
        body: child,
      ),
    );
  }
}
