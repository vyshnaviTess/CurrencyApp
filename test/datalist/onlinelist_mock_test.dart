import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:myflutterapp/datalist/datalist.dart';
import 'package:myflutterapp/model/currency.dart';

class MockOnlineCurrencyRatese implements CurrencyRates {
  @override
  late String selectedCurrencyCode;

  @override
  Future<List<GbpCurrency>> getRates() async {
    final tempRates = await _getLatestConversionRates();
    final currencies = await _getLatestCurrencies();
    List<GbpCurrency> rates = [];
    tempRates.forEach((key, value) => {
          rates.add(
            GbpCurrency(
              currency: currencies[key],
              currencyCode: key,
              amount: value.toDouble(),
            ),
          )
        });
    return Future.value(rates);
  }

  Future<Map<String, dynamic>> _getLatestConversionRates() async {
    final stubFile = '$selectedCurrencyCode.json';
    final Map<String, dynamic> response =
        await parseJsonFromAssets('fixtures/$stubFile');

    return response[selectedCurrencyCode] ?? {};
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  Future<Map<String, dynamic>> _getLatestCurrencies() async {
    const stubFile = 'currencies.json';
    final Map<String, dynamic> response =
        await parseJsonFromAssets('fixtures/$stubFile');
    return response ?? {};
  }
}
