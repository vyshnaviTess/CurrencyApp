import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myflutterapp/datalist/offline/hive_data.dart';
import 'package:myflutterapp/datalist/online/onlinelist.dart';
import 'package:myflutterapp/model/CurrencyNotifier.dart';
import 'package:myflutterapp/pages/searchlist.dart';
import 'package:provider/provider.dart';

void main() {
  Widget widgetToPump({required String hintText}) {
    final keySearchBar = GlobalKey<SearchWidgetState>();

    final controller = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => CurrencyNotifier(
        localRateService: HiveDataRates.instance,
        remoteRateService: OnlineCurrencyRates(),
      ),
      child: MaterialApp(
        home: Scaffold(
          body: Consumer<CurrencyNotifier>(
            builder: (context, notifier, child) {
              return SearchWidget(
                key: keySearchBar,
                controller: controller,
                hintText: hintText,
                onSearch: (searchTerm) {},
                onClear: () {
                  resetMockitoState();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  group('Search Bar Widget Tests', () {
    const hintText = 'Currency name or code';

    testWidgets('Checks for sub-elements', (WidgetTester tester) async {
      await tester.pumpWidget(widgetToPump(hintText: hintText));
      final searchBarFinder = find.byType(SearchWidget);
      final searchTextFieldFinder =
          find.byKey(const Key('search_bar_text_field'));

      final searchBarIconFinder = find.descendant(
        of: searchBarFinder,
        matching: find.byIcon(Icons.search),
      );
      expect(
        searchBarFinder,
        findsOneWidget,
        reason: 'Search Widget was not found',
      );
      expect(
        searchBarIconFinder,
        findsOneWidget,
        reason: 'No Search Widget Icon was found',
      );
      final searchTextField =
          tester.widget(searchTextFieldFinder.first) as TextField;

      expect(null, isNot(equals(searchTextField.decoration?.hintText)),
          reason: 'Search bar placeholder is missing');
      expect(hintText, equals(searchTextField.decoration?.hintText),
          reason: 'Search bar placeholder is wrong');

      expect(true, equals(searchTextField.controller?.text.isEmpty == true),
          reason: 'Search bar initialized with search text');
    });

    testWidgets(
        'When the search bar first loads it should have a \'Text Field\'',
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetToPump(hintText: hintText));
      final searchTextFieldFinder = find.byType(TextField).first;
      expect(searchTextFieldFinder, findsOneWidget);
    });

    testWidgets(
        'When the search bar first loads it should have a TextEditingController text value should be empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetToPump(hintText: hintText));
      final searchTextFieldFinder = find.byType(TextField).first;
      final searchTextField =
          tester.widget(searchTextFieldFinder.first) as TextField;
      expect(searchTextField.controller?.text.isEmpty, equals(true));
    });

    testWidgets(
        'When text is entered into the search bar the TextEditingController text should update with the said text',
        (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(widgetToPump(hintText: hintText));
      final searchTextFieldFinder = find.byType(TextField).first;
      final searchTextField =
          tester.widget(searchTextFieldFinder.first) as TextField;
      await tester.tap(searchTextFieldFinder);
      // When
      await tester.enterText(searchTextFieldFinder, 'Leo');
      // Then
      expect(searchTextField.controller?.text, equals('Leo'));
    });

    testWidgets(
        'When the search bar is initialised the clear button should be invisible',
        (WidgetTester tester) async {
      // When
      await tester.pumpWidget(widgetToPump(hintText: hintText));
      // Then
      expect(find.byKey(const Key('search_bar_close_button')), findsNothing,
          reason: 'Expects no clear icon until search text is entered');
    });

    testWidgets(
        'When text is entered into the search bar the clear button should be visible',
        (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(widgetToPump(hintText: hintText));
      await tester.pumpAndSettle();
      final searchTextFieldFinder = find.byType(TextField);
      await tester.tap(searchTextFieldFinder);
      // When
      await tester.enterText(searchTextFieldFinder, 'Some search term');
      await tester.pump();
      //Then
      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
