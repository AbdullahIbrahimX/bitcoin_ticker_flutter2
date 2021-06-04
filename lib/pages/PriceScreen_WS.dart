import 'dart:io' show Platform;

import 'package:bitcoin_ticker_flutter2/components/CoinCardRate.dart';
import 'package:bitcoin_ticker_flutter2/pages/AddNewCoin.dart';
import 'package:bitcoin_ticker_flutter2/services/DBHelper.dart';
import 'package:bitcoin_ticker_flutter2/services/constants.dart';
import 'package:bitcoin_ticker_flutter2/services/kracken_ws.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WSPriceScreen extends StatefulWidget {
  @override
  _WSPriceScreenState createState() => _WSPriceScreenState();
}

class _WSPriceScreenState extends State<WSPriceScreen> {
  final dbHelper = DBHelper.instance;
  String selectedCurrency = "USD";
  List<String> cryptoList = [];

  @override
  void initState() {
    connectToWsServer();
    super.initState();
  }

  addToCryptoList(List<String> newList) {
    newList
      ..forEach((element) {
        cryptoList.add(element);
      });
  }

  void connectToWsServer() async {
    await getUserSavedCryptoList();
    KrakenWS.subscribeToPairs(selectedCurrency, cryptoList);
    KrakenWS.listenToCoinErrors();
  }

  Future<void> getUserSavedCryptoList() async {
    List<Map<String, dynamic>> savedCryptoList = await dbHelper.queryAllRows();
    savedCryptoList.forEach((element) {
      setState(() {
        cryptoList.add(element[DBHelper.columnCryptoName]);
      });
    });
    return;
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
        KrakenWS.unsubscribeAll();
        KrakenWS.subscribeAll(selectedCurrency, cryptoList);
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
          setState(() {
            selectedCurrency = currenciesList[selectedItem];
          });
          KrakenWS.unsubscribeAll();
          KrakenWS.subscribeAll(selectedCurrency, cryptoList);
        },
        children: currencyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewCoin(
                      selectedCurrency, cryptoList, addToCryptoList)));
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: CoinRateCards(),
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
