import 'package:flutter/material.dart';
import 'package:myflutterapp/model/CurrencyNotifier.dart';
import 'package:myflutterapp/model/currency.dart';
import 'package:provider/provider.dart';

class CurrencyListView extends StatefulWidget {
  final List<GbpCurrency> currencies;
  final Function onRefresh;
  final Function onNavigationComplete;

  const CurrencyListView({
    Key? key,
    required this.currencies,
    required this.onRefresh,
    required this.onNavigationComplete,
  }) : super(key: key);

  @override
  CurrencyListViewState createState() => CurrencyListViewState();
}

class CurrencyListViewState extends State<CurrencyListView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: UniqueKey(),
      backgroundColor: Theme.of(context).backgroundColor,
      color: Theme.of(context).colorScheme.primaryVariant,
      strokeWidth: 4,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: _refresh,
      child: ListView.separated(
        key: UniqueKey(),
        itemCount: context.read<CurrencyNotifier>().filterCurrencies.length,
        itemBuilder: (context, index) {
          List<GbpCurrency> currencies =
              Provider.of<CurrencyNotifier>(context).filterCurrencies;
          return buildItem(currencies[index]);
        },
        separatorBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(left: 100),
          child: const Divider(
            color: Colors.black,
          ),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  ListTile buildItem(GbpCurrency rate) {
    final imagePath =
        "https://raw.githubusercontent.com/transferwise/currency-flags/master/src/flags/${rate.currencyCode}.png";
    final cryptoIconPath =
        "https://cryptoicons.org/api/color/${rate.currencyCode}/100";
    final cryptoIconPath2 =
        "https://cryptoicon-api.vercel.app/api/icon/${rate.currencyCode}";
    return ListTile(
      key: ObjectKey(rate),
      contentPadding:
          const EdgeInsets.only(left: 0, top: 0, right: 10, bottom: 0),
      leading: SizedBox(
        width: 100,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/loading.gif',
          image: imagePath,
          imageErrorBuilder: (context, obj, trace) {
            return FadeInImage.assetNetwork(
              placeholder: 'assets/images/loading.gif',
              image: cryptoIconPath2,
              imageErrorBuilder: (context, obj, trace) {
                return Placeholder();
              },
            );
          },
        ),
      ),
      title: Text('${rate.currencyCode.toUpperCase()} ${rate.amount}'),
      subtitle: Text(rate.currency.toUpperCase()),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: Colors.black,
        size: 38,
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          rate.currencyCode,
          arguments: {
            'rate': rate,
          },
        ).whenComplete(() => widget.onNavigationComplete);
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {
      widget.onRefresh();
    });
  }
}
