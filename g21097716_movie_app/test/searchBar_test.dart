import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cinematic_insights/Widgets/customSearchBar.dart';

void main() {
  testWidgets('Entered text is properly recorded', (WidgetTester tester) async {
    // Build the CustomSearchBar widget wrapped with MaterialApp
    await tester.pumpWidget(MaterialApp(
      home: CustomSearchBar(),
    ));

    // Enter text into the search field
    await tester.enterText(find.byType(TextField), 'Test Search Text');

    // Verify if the entered text is properly recorded
    CustomSearchBarState searchBarState = tester.state(find.byType(CustomSearchBar));
    expect(searchBarState.searchValue, 'Test Search Text');
  });
}