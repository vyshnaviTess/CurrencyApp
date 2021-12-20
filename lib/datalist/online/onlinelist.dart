import 'dart:convert';

import 'package:http/http.dart';
import 'package:myflutterapp/datalist/datalist.dart';
import 'package:myflutterapp/model/currency.dart';

class OnlineCurrencyRates implements CurrencyRates {
  final Client _apiClient = Client();
  final String selectedCurrencyCode;

  OnlineCurrencyRates({
    required this.selectedCurrencyCode,
  });

  @override
  Future<List<GbpCurrency>> getRates() async {
    final gbRates = await _getLatestGBConversionRates();
    final currencies = await _getLatestCurrencies();
    List<GbpCurrency> rates = [];
    gbRates.forEach((key, value) => {
          rates.add(
            GbpCurrency(
              currency: currencies[key],
              currencyCode: key,
              amount: value.toDouble(),
            ),
          )
        });
    return Future.value(rates);
    // .where((rate) =>
    //     rate.currencyCode.toLowerCase().contains(query.toLowerCase()) ||
    //     rate.currency.toLowerCase().contains(query.toLowerCase()))
    // .toList());
  }

  Future<Map<String, dynamic>> _getLatestGBConversionRates() async {
    final url = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies/$selectedCurrencyCode.json');
    final response = await _apiClient.get(
      url,
      headers: {"Content-Type": "application/json; charset=utf-8"},
    ).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      return {};
    }
    return jsonDecode(response.body)[selectedCurrencyCode] ?? {};
  }

  Future<Map<String, dynamic>> _getLatestCurrencies() async {
    final url = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies.json');
    final response = await _apiClient.get(
      url,
      headers: {"Content-Type": "application/json; charset=utf-8"},
    ).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      return {};
    }
    return jsonDecode(response.body) ?? {};
  }
}
