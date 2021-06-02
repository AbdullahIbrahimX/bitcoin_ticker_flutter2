import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoinCard extends StatelessWidget {
  final String pairName;
  final double pairPrice;
  final String volume;
  final double changeAmount;
  final Color infoTextColor;
  //trending
  final double OAchangePercentage;
  final Color OAbackGroundColor;

  CoinCard(
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
                          pairPrice.toStringAsFixed(5),
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
                          changeAmount.toStringAsFixed(5),
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
                  OAchangePercentage.toStringAsFixed(2),
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
