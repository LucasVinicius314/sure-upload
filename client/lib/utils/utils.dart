import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> replaceAllRoutes(
      BuildContext context, String route) async {
    if (kDebugMode) {
      print('replacing all routes with [$route]');
    }

    await Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (route) => false);
  }

  static Future<void> replaceRoute(BuildContext context, String route) async {
    if (kDebugMode) {
      print('replacing route with [$route]');
    }

    await Navigator.of(context).pushReplacementNamed(route);
  }
}
