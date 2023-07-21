import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Utils {
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static Future<void> launchUrl(String url) async {
    await url_launcher.launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
  }

  static Future<void> replaceAllRoutes(
    BuildContext context,
    String route,
  ) async {
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

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
