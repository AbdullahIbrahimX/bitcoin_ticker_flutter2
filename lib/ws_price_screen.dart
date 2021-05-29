import 'dart:io' show Platform;

import 'package:bitcoin_ticker_flutter2/services/coin_rate_cards.dart';
import 'package:bitcoin_ticker_flutter2/services/constants.dart';
import 'package:bitcoin_ticker_flutter2/services/kracken_ws.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WSPriceScreen extends StatefulWidget {
  @override
  _WSPriceScreenState createState() => _WSPriceScreenState();
}

class _WSPriceScreenState extends State<WSPriceScreen> {
  String selectedCurrency = "USD";

  @override
  void initState() {
    connectToWsServer();
    super.initState();
  }

  void connectToWsServer() async {
    KrackenWS.subscribeToPairs(selectedCurrency, cryptoList);
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> currencyList = [];

    currenciesList.forEach((element) {
      currencyList.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });

    return DropdownButton<String>(
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value;
        });
        KrackenWS.unsubscribeAll();
        KrackenWS.subscribeAll(selectedCurrency, cryptoList);
      },
      value: selectedCurrency,
      items: currencyList,
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> currencyList = [];

    currenciesList.forEach((element) {
      currencyList.add(Text(element));
    });
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedItem) {
          selectedCurrency = currenciesList[selectedItem];
        },
        children: currencyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [CoinRateCards()],
                // children: cryptoRates.isEmpty ? loadingScreen : coinRateCards(),
                // children: loadingScreen,
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
