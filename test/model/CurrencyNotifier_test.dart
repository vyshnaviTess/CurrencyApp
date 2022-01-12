import 'package:flutter_test/flutter_test.dart';
import 'package:myflutterapp/datalist/offline/memory_data.dart';
import 'package:myflutterapp/datalist/online/onlinelist.dart';
import 'package:myflutterapp/model/CurrencyNotifier.dart';

main() {
  CurrencyNotifier makeSUT() {
    return CurrencyNotifier(
      localRateService: LocalMemoryRates(),
      remoteRateService: OnlineCurrencyRates(),
    );
  }

  group(
    'Currency Notifier Unit Tests',
    () {
      group('When CurrencyNotifier is initialised:', () {
        final sut = makeSUT();
        test(
          'Local and remote rate services should be initialised',
          () {
            expect(sut.localRateService, isNotNull);
            expect(sut.remoteRateService, isNotNull);
          },
        );

        test(
          'Filtered currencies list should be empty.',
          () {
            expect(sut.filterCurrencies, isEmpty);
          },
        );

        test(
          'Currencies codes list should be empty.',
          () {
            expect(sut.currencyCodes, isEmpty);
          },
        );
      });

      group('When currencyCodes has a valid currency:', () {
        final sut = makeSUT();
        sut.currencyCodes.add('gbp');
        test(
          'Currencies codes list should not be empty.',
          () {
            expect(sut.currencyCodes, isNotEmpty);
          },
        );

        test(
          'And when refresh is called \'filteredCurrencies\' list should not be empty.',
          () async {
            await sut.refreshCurrencies();
            await expectLater(sut.filterCurrencies, isNotEmpty);
          },
        );
      });

      group(
        'When the currencies are filtered only those items should be in the filteredCurrencies list',
        () {
          final sut = makeSUT();
          sut.currencyCodes.add('gbp');
          test(
            'When gbp list is filtered with search term \'Leo\' the filters list should only show 1 item, the Sierra Leonean leone',
            () async {
              await sut.refreshCurrencies();
              await expectLater(sut.filterCurrencies.length, greaterThan(1));
              await sut.filterCurrency('Leo');
              await expectLater(sut.filterCurrencies.length, equals(1));
              await expectLater(
                  sut.filterCurrencies.first.currencyCode, equals('sll'));
            },
          );
        },
      );
    },
  );
}
