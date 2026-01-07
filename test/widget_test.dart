// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:carpool_mvp_flutter/app/app.dart';
import 'package:carpool_mvp_flutter/di/app_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: AppDI.providers(),
        child: const CarpoolApp(),
      ),
    );

    // Let router + initial frames settle.
    await tester.pumpAndSettle();

    // Verify that the app starts.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
