import 'package:flutter/material.dart';

import 'kracken_ws.dart';

class CoinRateCards extends StatelessWidget {
  const CoinRateCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: KrackenWS.listen(), builder: (contex, stream) {});
  }
}
