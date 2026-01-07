import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/design_system/theme.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'router.dart';

class CarpoolApp extends StatefulWidget {
  const CarpoolApp({super.key});

  @override
  State<CarpoolApp> createState() => _CarpoolAppState();
}

class _CarpoolAppState extends State<CarpoolApp> {
  late final GoRouter _router;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final auth = context.read<AuthProvider>();
    _router = createRouter(auth: auth);
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Carpool MVP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      supportedLocales: const [Locale('en'), Locale('ur')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
