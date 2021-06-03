import 'package:bitcoin_ticker_flutter2/CoinCard.dart';
import 'package:bitcoin_ticker_flutter2/services/kracken_ws.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CoinRateCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, List<dynamic>>>(
        stream: KrakenWS.listenToCoinPrices(),
        builder: (context, snapshot) {
          List<Widget> widgetList = [];
          if (snapshot.data != null) {
            snapshot.data.forEach((key, value) {
              if (value.last) {
                widgetList.add(CoinCard(
                  pairName: value[3],
                  pairPrice: value[0],
                  volume: value[1],
                  changeAmount: value[4],
                  infoTextColor: value[6],
                  OAchangePercentage: value[5],
                  OAbackGroundColor: value[7],
                ));
              } else {
                widgetList.add(ErrorCard(errorMessage: value[0]));
              }
            });

            return ListView.builder(
                itemCount: widgetList.length,
                itemBuilder: (BuildContext context, int index) {
                  return widgetList[index];
                });
          } else {
            return LoadingScreen();
          }
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
