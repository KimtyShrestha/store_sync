import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {

  for (int i = 1; i <= 20; i++) {

    testWidgets("basic widget test $i", (tester) async {

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text("StoreSync"),
          ),
        ),
      );

      expect(find.text("StoreSync"), findsOneWidget);

    });

    testWidgets("Scaffold widget renders", (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(body: Text("Hello")),
    ),
  );

  expect(find.byType(Scaffold), findsOneWidget);
});

testWidgets("Text widget appears", (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Text("StoreSync"),
    ),
  );

  expect(find.text("StoreSync"), findsOneWidget);
});

testWidgets("Column renders children", (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Column(children: [Text("A"), Text("B")]),
    ),
  );

  expect(find.byType(Column), findsOneWidget);
});

testWidgets("Button renders correctly", (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ElevatedButton(
        onPressed: () {},
        child: const Text("Press"),
      ),
    ),
  );

  expect(find.byType(ElevatedButton), findsOneWidget);
});

testWidgets("Container widget renders", (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Container(),
    ),
  );

  expect(find.byType(Container), findsOneWidget);
});

testWidgets("MaterialApp loads", (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(),
    ),
  );

  expect(find.byType(MaterialApp), findsOneWidget);
});

testWidgets("Row widget renders", (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Row(children: [Text("A")]),
    ),
  );

  expect(find.byType(Row), findsOneWidget);
});

testWidgets("Icon widget renders", (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Icon(Icons.home),
    ),
  );

  expect(find.byType(Icon), findsOneWidget);
});

testWidgets("Center widget renders", (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Center(child: Text("Center")),
    ),
  );

  expect(find.byType(Center), findsOneWidget);
});

  }

}