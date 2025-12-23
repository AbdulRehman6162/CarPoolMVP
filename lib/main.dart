import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'di/app_di.dart';

void main() {
  runApp(
    MultiProvider(
      providers: AppDI.providers(),
      child: const CarpoolApp(),
    ),
  );
}
