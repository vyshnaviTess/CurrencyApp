import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myflutterapp/pages/currencylistview.dart';
import 'package:provider/provider.dart';

import '../model/CurrencyNotifier_mock.dart';

void main() {
  Widget widgetToPump() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => MockCurrencyNotifier(),
          builder: (context, _) {
            context.read<MockCurrencyNotifier>().updateCurrencies('gbp');
            return Consumer<MockCurrencyNotifier>(
              builder: (context, notifier, child) {
                return CurrencyListView(
                  currencies: notifier.filterCurrencies,
                  onRefresh: () {
                    notifier.updateCurrencies('inr');
                  },
                  onNavigationComplete: () {
                    notifier.refreshCurrencies();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  group('List View Tests', () {
    testWidgets(
      'When loaded the CurrencyListView should be displayed.',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        expect(find.byType(CurrencyListView), findsOneWidget);
      },
    );

    testWidgets(
      'List should have two(2) items.',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsNWidgets(2),
            reason: 'Found more or less than 2 items nin list');
      },
    );

    testWidgets(
      'Verify that the title of first list item is INR 100.9',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        final listTile = tester.widget(find.byType(ListTile).first) as ListTile;
        final title = listTile.title as Text;
        expect(title.data, equals('INR 100.9'));
      },
    );

    testWidgets(
      'Verify that the subtitle of first list item is INDIA.',
      (WidgetTester tester) async {
        await tester.pumpWidget(widgetToPump());
        final listTile = tester.widget(find.byType(ListTile).first) as ListTile;
        final subtitle = listTile.subtitle as Text;
        expect(subtitle.data, equals('INDIA'));
      },
    );
  });
}
