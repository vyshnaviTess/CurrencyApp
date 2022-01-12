import 'package:myflutterapp/datalist/offline/offlinelist.dart';
import 'package:myflutterapp/model/currency.dart';

abstract class CurrencyRates {
  late String selectedCurrencyCode;
  Future<List<GbpCurrency>> getRates() async {
    return [];
  }
}

class CurrencyRatesLocal implements CurrencyRates {
  final LocalDataRates local;
  final CurrencyRates remote;

  @override
  late String selectedCurrencyCode;

  CurrencyRatesLocal({
    required this.local,
    required this.remote,
  });

  @override
  Future<List<GbpCurrency>> getRates() async {
    try {
      final oldData = await local.getRates();
      if (oldData.isEmpty) {
        final freshData = await remote.getRates();
        if (freshData.isNotEmpty) {
          local.setRates(freshData);
        }
        return freshData;
      }
      return oldData;
    } catch (_) {
      return [];
    }
  }
}

class ConversionRatesRemote implements CurrencyRates {
  final CurrencyRates remote;
  final LocalDataRates local;

  @override
  late String selectedCurrencyCode;

  ConversionRatesRemote({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<GbpCurrency>> getRates() async {
    try {
      final freshData = await remote.getRates();
      if (freshData.isNotEmpty) {
        local.setRates(freshData);
        return freshData;
      }
      return local.getRates();
    } catch (_) {
      return local.getRates();
    }
  }
}
