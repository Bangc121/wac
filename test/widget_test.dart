// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wac/main.dart';

void main() {
  testWidgets('Bottom navigation bar smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts at the Home page.
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.text('Search Page'), findsNothing);

    // Tap the 'Search' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    // Verify that we have navigated to the Search page.
    expect(find.text('Home Page'), findsNothing);
    expect(find.text('Search Page'), findsOneWidget);

    // Tap the 'Notifications' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.notifications));
    await tester.pump();

    // Verify that we have navigated to the Notifications page.
    expect(find.text('Search Page'), findsNothing);
    expect(find.text('Notifications Page'), findsOneWidget);

    // Tap the 'Settings' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    // Verify that we have navigated to the Settings page.
    expect(find.text('Notifications Page'), findsNothing);
    expect(find.text('Settings Page'), findsOneWidget);

    // Tap the 'Profile' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.person));
    await tester.pump();

    // Verify that we have navigated to the Profile page.
    expect(find.text('Settings Page'), findsNothing);
    expect(find.text('Profile Page'), findsOneWidget);
  });
}
