import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            style: TextStyle(color: Colors.black, fontSize: 20),
          )
        ],
      ),
    );
  }
}
