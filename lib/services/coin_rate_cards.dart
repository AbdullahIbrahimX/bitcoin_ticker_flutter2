import 'dart:convert';

import 'package:bitcoin_ticker_flutter2/services/kracken_ws.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../CoinCard.dart';

class CoinRateCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: KrakenWS.listenToCoinPrices(),
        builder: (context, snapshot) {
          Map coinPayload = jsonDecode(snapshot.toString());
          if (coinPayload == null) {
            return LoadingScreen();
          }

          List<Widget> widgetList = [];
          coinPayload.forEach((key, value) {
            widgetList.add(
              CoinCard(
                pairName: value[3],
                pairPrice: value[0].toStringAsFixed(),
                volume: value[1].toString(),
                changeAmount: value[4],
                infoTextColor: compare(value[0], value[0]),
                OAchangePercentage: '${value[5]}%',
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

// class CoinCard extends StatelessWidget {
//   final String cryptoName;
//   final String rate;
//
//   const CoinCard({this.cryptoName, this.rate});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.lightBlueAccent,
//       elevation: 5.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
//         child: Text(
//           '1 $cryptoName = $rate',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 20.0,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
