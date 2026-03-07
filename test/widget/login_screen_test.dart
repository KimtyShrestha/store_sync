import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_sync/features/auth/presentation/pages/login_screen.dart';

void main() {

  testWidgets("login screen loads correctly", (WidgetTester tester) async {

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // check for email field
    expect(find.byType(TextField), findsWidgets);

  });

}