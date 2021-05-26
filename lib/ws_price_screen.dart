import 'dart:io' show Platform;

import 'package:bitcoin_ticker_flutter2/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'file:///C:/Users/abuar/AndroidStudioProjects/bitcoin_ticker_flutter2/test/TestWidget.dart';

import 'coin_data.dart';

class WSPriceScreen extends StatefulWidget {
  @override
  _WSPriceScreenState createState() => _WSPriceScreenState();
}

class _WSPriceScreenState extends State<WSPriceScreen> {
  List<Map<String, dynamic>> cryptoRates = [];
  String selectedCurrency = "USD";
  CoinData coinData = CoinData();
  List<Widget> loadingScreen = [
    Padding(
      padding: EdgeInsets.only(top: 200.0),
      child: Column(
        children: [
          SpinKitFadingGrid(
            color: Colors.lightBlueAccent,
            size: 50,
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "Loading Crypto Data...",
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    ),
  ];

  @override
  void initState() {
    // getAppData();
    super.initState();
  }

  void getAppData() async {
    var dummy;
    coinData = CoinData();
    dummy = await coinData.getCoinData(currency: selectedCurrency);
    setState(() {
      cryptoRates = dummy;
    });
  }

  List<Widget> coinRateCards() {
    List<Widget> cards = [];
    cryptoRates.forEach((e) {
      cards.add(Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 ${e["Crypto"]} = ${e["rate"]} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ));
    });
    return cards;
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
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          cryptoRates = coinData.getAllCryptoRates(currency: selectedCurrency);
        });
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
                children: cryptoRates.isEmpty ? loadingScreen : coinRateCards(),
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
          TestWidget(), //TODO delete me
        ],
      ),
    );
  }
}
