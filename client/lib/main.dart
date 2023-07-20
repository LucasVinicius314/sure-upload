import 'package:flutter/material.dart';
import 'package:sure_upload/core/app.dart';
import 'package:sure_upload/core/bloc_providers.dart';
import 'package:sure_upload/core/repository_providers.dart';

void main() {
  runApp(
    const RepositoryProviders(child: BlocProviders(child: App())),
  );
}
