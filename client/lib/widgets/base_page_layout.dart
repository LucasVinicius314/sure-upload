import 'package:flutter/material.dart';
import 'package:sure_upload/utils/constants.dart';

class BasePageLayout extends StatelessWidget {
  const BasePageLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Divider(height: 0),
        ),
      ),
      body: child,
    );
  }
}
