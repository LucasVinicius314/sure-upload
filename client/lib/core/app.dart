import 'package:flutter/material.dart';
import 'package:sure_upload/screens/home_page.dart';
import 'package:sure_upload/screens/login_page.dart';
import 'package:sure_upload/utils/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        HomePage.route: (context) => const HomePage(),
        LoginPage.route: (context) => const LoginPage(),
      },
    );
  }
}
