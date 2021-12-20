import 'package:myflutterapp/model/currency.dart';
import 'package:myflutterapp/datalist/datalist.dart';

//cache data
abstract class LocalDataRates implements CurrencyRates {
  Future<void> setRates(List<GbpCurrency> newRates);
}
