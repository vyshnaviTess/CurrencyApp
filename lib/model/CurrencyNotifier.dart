import 'package:flutter/foundation.dart';
import 'package:myflutterapp/datalist/datalist.dart';
import 'package:myflutterapp/datalist/offline/hive_data.dart';
import 'package:myflutterapp/datalist/online/onlinelist.dart';
import 'package:myflutterapp/model/currency.dart';

class CurrencyNotifier with ChangeNotifier {
  List<String> currencyCodes = [];

  late bool _shouldRefresh;
  List<GbpCurrency> _currencies = [];
  List<GbpCurrency> _filterCurrencies = [];
  List<GbpCurrency> get filterCurrencies => _filterCurrencies;

  CurrencyRates get _dataService {
    if (_shouldRefresh) {
      return ConversionRatesRemote(
        remote: OnlineCurrencyRates(selectedCurrencyCode: currencyCodes.last),
        local: HiveDataRates.instance,
      );
    } else {
      return CurrencyRatesLocal(
        local: HiveDataRates.instance,
        remote: OnlineCurrencyRates(selectedCurrencyCode: currencyCodes.last),
      );
    }
  }

  Future<void> updateCurrencies(String currencyCode) async {
    _shouldRefresh = false;
    _setCurrencies(await _dataService.getRates());
    notifyListeners();
  }

  Future<void> refreshCurrencies() async {
    _shouldRefresh = true;
    _setCurrencies(await _dataService.getRates());
    notifyListeners();
  }

  Future<void> filterCurrency(term) async {
    _filterCurrencies = _currencies
        .where(
          (e) => (e.currency
                  .toLowerCase()
                  .toString()
                  .contains(term.toLowerCase()) ||
              e.currencyCode
                  .toLowerCase()
                  .toString()
                  .contains(term.toLowerCase())),
        )
        .toList();
    notifyListeners();
  }

  void _setCurrencies(List<GbpCurrency> currencies) {
    currencies.removeWhere((element) =>
        element.currencyCode.toLowerCase().trim() ==
        currencyCodes.last.toLowerCase().trim());
    _currencies = currencies;
    _filterCurrencies = currencies;
  }
}
