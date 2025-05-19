// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busmap/main.dart';

void main() {
  testWidgets('BMTC app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyBmtcApp());

    // Verify that the app title is correct
    expect(find.text('MyBMTC'), findsOneWidget);

    // Verify that the map screen is shown
    expect(find.byType(Scaffold), findsOneWidget);

    // More specific tests would require mocking Google Maps and location services
    // which is beyond the scope of this basic smoke test
  });
}
