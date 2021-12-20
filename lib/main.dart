import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myflutterapp/model/CurrencyNotifier.dart';
import 'package:myflutterapp/pages/CurrencyDetails.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrencyNotifier(),
      child: MaterialApp(
        title: 'NTT Data Rates',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          accentColor: Colors.blue,
        ),
        routes: {
          '/': (context) => CurrencyDetails(
                title: 'NTTData Curriencies',
                currencyCode: 'gbp',
              ),
        },
        onGenerateRoute: (settings) {
          return CupertinoPageRoute(
            builder: (BuildContext context) {
              return CurrencyDetails(
                title: "NTTData",
                currencyCode: settings.name ?? "/",
              );
            },
          );
        },
      ),
    );
  }
}
