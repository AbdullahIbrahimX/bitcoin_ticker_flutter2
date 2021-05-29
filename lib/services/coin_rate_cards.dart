import 'dart:convert';

import 'package:bitcoin_ticker_flutter2/services/kracken_ws.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constants.dart';

class CoinRateCards extends StatefulWidget {
  const CoinRateCards({Key key}) : super(key: key);

  @override
  _CoinRateCardsState createState() => _CoinRateCardsState();
}

class _CoinRateCardsState extends State<CoinRateCards> {
  Map _coinPrices = {};
  List<Widget> widgetList = [];

  @override
  void initState() {
    for (String crypto in cryptoList) {
      _coinPrices.addAll({crypto: '0'});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: KrackenWS.listenToCoinPrices(),
        builder: (context, snapshot) {
          List<dynamic> coinPayload = jsonDecode(snapshot.data.toString());
          if (coinPayload == null) {
            return LoadingScreen();
          }
          List<dynamic> coinData = coinPayload[1];
          _coinPrices.update(coinPayload.last.toString().substring(0, 3),
              (value) => coinData.first[0].toString());

          widgetList.clear();
          _coinPrices.forEach((key, value) {
            widgetList.add(CoinCard(
              cryptoName: key,
              rate: value,
            ));
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgetList,
          );
        });
  }
}

class CoinCard extends StatelessWidget {
  final String cryptoName;
  final String rate;

  const CoinCard({this.cryptoName, this.rate});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoName = $rate',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
