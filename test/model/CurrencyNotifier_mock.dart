import 'package:mockito/mockito.dart';
import 'package:myflutterapp/model/CurrencyNotifier.dart';
import 'package:myflutterapp/model/currency.dart';

class MockCurrencyNotifier extends Mock implements CurrencyNotifier {
  List<GbpCurrency> _currencies = [];
  List<GbpCurrency> _filterCurrencies = [];

  @override
  List<GbpCurrency> get filterCurrencies => _filterCurrencies;

  @override
  Future<void> updateCurrencies(String currencyCode) async {
    if (currencyCode.toLowerCase() == 'inr') {
      _currencies = [
        GbpCurrency(
          currency: 'Trinidad & Tobago',
          currencyCode: 'ttd',
          amount: 9.19,
        )
      ];
    } else {
      _currencies = [
        GbpCurrency(
          currency: 'India',
          currencyCode: 'inr',
          amount: 100.9,
        ),
        GbpCurrency(
          currency: 'Trinidad & Tobago',
          currencyCode: 'ttd',
          amount: 9.19,
        )
      ];
    }
    _filterCurrencies = _currencies;
    notifyListeners();
  }

  @override
  Future<void> refreshCurrencies() async {
    _filterCurrencies = _currencies;
    notifyListeners();
  }
}
