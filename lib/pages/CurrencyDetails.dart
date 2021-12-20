import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myflutterapp/model/CurrencyNotifier.dart';
import 'package:myflutterapp/pages/currencylistview.dart';
import 'package:myflutterapp/pages/searchlist.dart';
import 'package:provider/provider.dart';

class CurrencyDetails extends StatefulWidget {
  final String title;
  final String currencyCode;

  CurrencyDetails({
    Key? key,
    required this.title,
    required this.currencyCode,
  }) : super(key: key);

  final controllerSearch = TextEditingController();
  final keySearchBar = GlobalKey<SearchWidgetState>();

  @override
  State<CurrencyDetails> createState() => _CurrencyDetailsState();
}

class _CurrencyDetailsState extends State<CurrencyDetails> {
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
    final currencyNotifier = context.read<CurrencyNotifier>();
    currencyNotifier.currencyCodes.add(widget.currencyCode);
    currencyNotifier.refreshCurrencies();
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (_debouncer != null) {
      _debouncer!.cancel();
    }
    _debouncer = Timer(duration, callback);
  }

  Widget? _backButton() {
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.grey,
          size: 38,
        ),
        onPressed: () {
          CurrencyNotifier notifier = context.read<CurrencyNotifier>();
          notifier.currencyCodes.removeLast();
          context.read<CurrencyNotifier>().refreshCurrencies();
          Navigator.of(context).pop();
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: _backButton(),
          centerTitle: false,
          title: Text(
            '${widget.title} - ${widget.currencyCode.toUpperCase()}',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          backgroundColor: Colors.black87,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          actionsIconTheme: const IconThemeData(
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Consumer<CurrencyNotifier>(
          builder: (context, notifier, child) {
            return Column(
              children: [
                _buildSearchWidget(),
                Expanded(
                  child: CurrencyListView(
                    currencies: notifier.filterCurrencies,
                    onRefresh: () {
                      widget.controllerSearch.clear();
                      notifier.refreshCurrencies();
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }

  Widget _buildLoadingWidget() {
    return Center(
      key: UniqueKey(),
      child: const Text(
        'Please wait, loading rates...',
      ),
    );
  }

  Widget _buildSearchWidget() {
    return SearchWidget(
      key: widget.keySearchBar,
      text: '',
      controller: widget.controllerSearch,
      hintText: 'Currency name or code',
      onChanged: (String value) {},
    );
  }
}
