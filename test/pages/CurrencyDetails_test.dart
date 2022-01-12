import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myflutterapp/main.dart';
import 'package:myflutterapp/pages/currencylistview.dart';
import 'package:myflutterapp/pages/searchlist.dart';

void main() {
  Widget widgetToPump() {
    return const MyApp();
  }

  group('Rates Page Integration Tests', () {
    testWidgets(
      'When loaded initially the Rates Page should have a title of NTTData - GBP',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        final appBar = tester.widget(find.byType(AppBar)) as AppBar;
        final titleText = appBar.title as Text;
        expect(titleText.data, equals('NTTData - GBP'));
      },
    );

    testWidgets(
      'When loaded initially the Rates Page should contain the search bar',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        expect(find.byType(SearchWidget), findsOneWidget);
      },
    );

    testWidgets(
      'When loaded initially the Rates Page should contain the rates list view',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        expect(find.byType(CurrencyListView), findsOneWidget);
      },
    );

    testWidgets(
      'When loaded initially the Rates Page should contain a ListView widget',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        expect(find.byType(ListView), findsOneWidget);
      },
    );
  });
}
