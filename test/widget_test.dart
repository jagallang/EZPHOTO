import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pol_photo/main.dart';

void main() {
  testWidgets('REphoto App smoke test', (WidgetTester tester) async {
    // Setup EasyLocalization for testing
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [
          Locale('ko'),
          Locale('en'),
          Locale('ja'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ko'),
        startLocale: const Locale('ko'),
        child: const PhotoLayoutApp(),
      ),
    );

    // Wait for localization to load
    await tester.pumpAndSettle();

    // Verify that the app loads correctly
    // Check for app bar or floating action button
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsWidgets);
  });
}