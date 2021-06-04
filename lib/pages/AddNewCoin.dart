import 'package:bitcoin_ticker_flutter2/components/LoadingScreen.dart';
import 'package:bitcoin_ticker_flutter2/services/DBHelper.dart';
import 'package:bitcoin_ticker_flutter2/services/Networking.dart';
import 'package:bitcoin_ticker_flutter2/services/kracken_ws.dart';
import 'package:flutter/material.dart';

class AddNewCoin extends StatefulWidget {
  final String currency;
  final List<String> pervList;
  final Function addToViewList;

  AddNewCoin(this.currency, this.pervList, this.addToViewList);

  @override
  _AddNewCoinState createState() => _AddNewCoinState();
}

class _AddNewCoinState extends State<AddNewCoin> {
  final dbHelper = DBHelper.instance;
  final networkHelper =
      NetworkHelper(website: 'api.kraken.com', path: '/0/public/AssetPairs');
  Map<String, bool> availablePairs = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var callResult = await networkHelper.getData();
    Map assetInfo = callResult['result'];
    assetInfo.forEach((key, value) {
      if (value['wsname'] != null) {
        List<String> pairPart = value['wsname'].toString().split('/');
        if (pairPart[1].toString() == widget.currency) {
          if (!widget.pervList.contains(pairPart[0].toString())) {
            setState(() {
              availablePairs[value['wsname'].toString()] = false;
            });
          }
        }
      }
    });
  }

  toggleCheckBox(String cryptoPair, bool currentCheckBoxValue) {
    setState(() {
      availablePairs[cryptoPair] = !currentCheckBoxValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (availablePairs.isEmpty) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [LoadingScreen()],
          ),
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: availablePairs.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = availablePairs.keys.elementAt(index);
                  return ChoseCoinCard(
                      key, availablePairs[key], toggleCheckBox);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.blueAccent,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      List<String> subList = [];
                      availablePairs.forEach((key, value) {
                        if (value) {
                          subList.add(key.toString().split('/')[0]);
                        }
                      });
                      KrakenWS.subscribeAll(widget.currency, subList);
                      subList.forEach((element) {
                        dbHelper.insert({DBHelper.columnCryptoName: element});
                      });
                      widget.addToViewList(subList);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.redAccent,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ChoseCoinCard extends StatelessWidget {
  final String pairName;
  final bool checkBoxControl;
  final Function toggleCheckBox;

  ChoseCoinCard(this.pairName, this.checkBoxControl, this.toggleCheckBox);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          toggleCheckBox(pairName, checkBoxControl);
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: checkBoxControl ? Colors.greenAccent : Colors.grey,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
          child: Row(
            children: [
              Checkbox(value: checkBoxControl, onChanged: (e) {}),
              Text(pairName),
            ],
          ),
        ));
  }
}
