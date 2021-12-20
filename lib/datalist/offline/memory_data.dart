import 'package:myflutterapp/datalist/offline/offlinelist.dart';
import 'package:myflutterapp/model/currency.dart';

class LocalMemoryRates implements LocalDataRates {
  List<GbpCurrency> rates = [];

  LocalMemoryRates._privateConstructor();
  static final LocalMemoryRates instance =
      LocalMemoryRates._privateConstructor();

  @override
  Future<List<GbpCurrency>> getRates() async {
    // if (query.isNotEmpty) {
    //   final filteredRates = rates
    //       .where((a) =>
    //           a.currency.toLowerCase().contains(query.toLowerCase()) ||
    //           a.currencyCode.toLowerCase().contains(query.toLowerCase()))
    //       .toList();
    //   return Future.value(filteredRates);
    // }
    return Future.value(rates);
  }

  @override
  Future<void> setRates(List<GbpCurrency> newRates) async {
    rates = newRates;
  }
}
