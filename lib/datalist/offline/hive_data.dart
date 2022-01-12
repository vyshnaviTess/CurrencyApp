import 'package:hive/hive.dart';
import 'package:myflutterapp/datalist/offline/offlinelist.dart';
import 'package:myflutterapp/model/currency.dart';
import 'package:path_provider/path_provider.dart';

class HiveDataRates implements LocalDataRates {
  HiveDataRates._privateConstructor();
  static final HiveDataRates instance = HiveDataRates._privateConstructor();
  static const _boxName = 'ntt_rates';
  static const _key = 'rates';

  @override
  Future<List<GbpCurrency>> getRates() async {
    var box = await _openHiveBox();
    final List<Map<String, dynamic>> rates = await box.get(_key);
    final result = rates.map((e) => e.toConversionRate()).toList();
    return Future.value(result);
  }

  @override
  Future<void> setRates(List<GbpCurrency> newRates) async {
    List<Map<String, dynamic>> rates = newRates.map((e) => e.toMap()).toList();
    var box = await _openHiveBox();
    await box.put(_key, rates);
  }

  Future<Box> _openHiveBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }
    return Hive.openBox(_boxName);
  }

  @override
  late String selectedCurrencyCode;
}

extension _GbpConversionRateMapConverter on GbpCurrency {
  Map<String, dynamic> toMap() {
    return {
      'currency': currency,
      'currencyCode': currencyCode,
      'amount': amount,
    };
  }
}

extension _GbpConversionRateConverter on Map<String, dynamic> {
  GbpCurrency toConversionRate() {
    return GbpCurrency(
      currency: this['currency'],
      currencyCode: this['currencyCode'],
      amount: this['amount'],
    );
  }
}
