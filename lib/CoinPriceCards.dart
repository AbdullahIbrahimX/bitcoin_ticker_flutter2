import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CoinCard2(
          pairName: 'XBT/USD',
          pairPrice: '39459.2466',
          volume: '0.15673',
          changeAmount: '+4000',
          infoTextColor: Colors.greenAccent,
          OAchangePercentage: '19%',
          OAbackGroundColor: Colors.redAccent,
        ),
        CoinCard2(
          pairName: 'ETH/USD',
          pairPrice: '2459.2466',
          volume: '0.15673',
          changeAmount: '-4000',
          infoTextColor: Colors.redAccent,
          OAchangePercentage: '10.24%',
          OAbackGroundColor: Colors.greenAccent,
        ),
        CoinCard2(
          pairName: 'XBT/USD',
          pairPrice: '39459.2466',
          volume: '0.15673',
          changeAmount: '+4000',
          infoTextColor: Colors.lightGreenAccent,
          OAchangePercentage: '19%',
          OAbackGroundColor: Colors.redAccent,
        ),
        CoinCard2(
          pairName: 'XBT/USD',
          pairPrice: '39459.2466',
          volume: '0.15673',
          changeAmount: '+4000',
          infoTextColor: Colors.lightGreenAccent,
          OAchangePercentage: '19%',
          OAbackGroundColor: Colors.redAccent,
        ),
      ],
    );
  }
}

class CoinCard2 extends StatelessWidget {
  final String pairName;
  final String pairPrice;
  final String volume;
  final String changeAmount;
  final Color infoTextColor;
  //trending
  final String OAchangePercentage;
  final Color OAbackGroundColor;

  CoinCard2(
      {this.pairName,
      this.pairPrice,
      this.volume,
      this.changeAmount,
      this.infoTextColor,
      this.OAchangePercentage,
      this.OAbackGroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.blueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          pairName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: infoTextColor,
                          ),
                        ),
                        Text(
                          pairPrice,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: infoTextColor,
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          volume,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: infoTextColor,
                          ),
                        ),
                        Text(
                          changeAmount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: infoTextColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.zero,
              color: OAbackGroundColor,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              child: Center(
                child: Text(
                  OAchangePercentage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
