import 'dart:convert';

import 'package:bitcoin_ticker_flutter2/services/kracken_ws.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../CoinCard.dart';

class CoinRateCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: KrakenWS.listenToCoinPrices2(),
        builder: (context, snapshot) {
          if (snapshot == null) {
            return LoadingScreen();
          }
          Map<String, List<dynamic>> coinPayload = jsonDecode(snapshot.data);

          List<Widget> widgetList = [];
          coinPayload.forEach((key, value) {
            widgetList.add(
              CoinCard(
                pairName: value[3],
                pairPrice: value[0],
                volume: value[1],
                changeAmount: value[4],
                infoTextColor: value[6],
                OAchangePercentage: value[5],
                OAbackGroundColor: value[7],
              ),
            );
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgetList,
          );
        });
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
