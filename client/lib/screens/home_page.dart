import 'package:flutter/material.dart';
import 'package:sure_upload/screens/login_page.dart';
import 'package:sure_upload/utils/constants.dart';

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
      await Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.route, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(Constants.appName),
      ),
    );
  }
}
