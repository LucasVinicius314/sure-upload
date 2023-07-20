import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sure_upload/blocs/user_bloc.dart';
import 'package:sure_upload/screens/login_page.dart';
import 'package:sure_upload/utils/utils.dart';
import 'package:sure_upload/widgets/base_page_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future(() async {
      if (context.read<UserBloc>().state is! LoginDoneState) {
        await Utils.replaceAllRoutes(context, LoginPage.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePageLayout(child: Container());
  }
}
