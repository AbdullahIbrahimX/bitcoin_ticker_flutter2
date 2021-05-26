import 'package:flutter/material.dart';

import 'services/kracken_ws.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  String test = 'not connected yet';

  @override
  void initState() {
    connectToWebSocket();
    super.initState();
  }

  connectToWebSocket() async {
    KrackenWS.subscribe('crypto', 'currency');
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      test,
      style: TextStyle(color: Colors.black),
    );
  }
}
