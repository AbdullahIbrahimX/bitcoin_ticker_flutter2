import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';

const Map<String, Map> KrakenEvents = {
  'subscribe': {
    "event": "subscribe",
    "subscription": {"name": "trade"}
  },
  'unsubscribe': {
    "event": "unsubscribe",
    "subscription": {"name": "trade"}
  }
};

class KrackenWS {
  static IOWebSocketChannel _channel;
  static Stream _stream;
  static String _uri = 'wss://ws.kraken.com';
  static List<String> _cryptoPairs = [];
  static var _codec = new JsonCodec().fuse(new Utf8Codec());

  static subscribeToPairs(String currency, List<String> cryptoList) async {
    for (String crypto in cryptoList) {
      _cryptoPairs.add('$crypto/$currency');
    }
    _init();
    //TODO add take(2);
    _stream.listen((event) {
      dynamic message = jsonDecode(event);

      if (message != null &&
          message is! List<dynamic> &&
          message.containsKey('event')) {
        if (message['event'] == 'systemStatus' &&
            message['status'] == 'online') {
          List<int> subEvent = _codec
              .encode({...KrakenEvents['subscribe'], 'pair': _cryptoPairs});
          _channel.sink.add(subEvent);
          return;
        }
      }
      print(message);
    });
  }

  static Stream listenToCoinPrices() {
    Stream coinData =
        _stream.where((event) => jsonDecode(event) is List<dynamic>);
    return coinData;
  }

  static closeConnection() async {
    _channel.sink.close();
  }

  static _init() {
    if (_cryptoPairs.isEmpty) return;
    if (_channel != null) return;

    _channel = IOWebSocketChannel.connect(Uri.parse(_uri),
        pingInterval: Duration(seconds: 4));

    _stream = _channel.stream.asBroadcastStream();
  }
}
//
// class KrackenWS {
//   static String _uri = 'wss://ws.kraken.com';
//   static List<String> _crypto;
//   static String _currency;
//   static List<String> _pairs = [];
//   static IOWebSocketChannel _channel;
//   static var _codec = new JsonCodec().fuse(new Utf8Codec());
//
//   static _initialize() async {
//     if (_channel != null) return;
//     if (_crypto == null || _currency == null) {
//       print('no currency or crypto');
//       return;
//     }
//     _channel = IOWebSocketChannel.connect(Uri.parse(_uri),
//         pingInterval: Duration(seconds: 4));
//     print('initialized');
//   }
//
//   static Stream<List> listen() async* {
//     _initialize();
//     _channel.stream.listen((event) {
//       dynamic message = jsonDecode(event);
//       print(message);
//
//       if (message.isNotEmpty) {
//         if (message is List || message is List<dynamic>) {
//           print('list');
//           print(message);
//         } else {
//           print('Message type : ${message.runtimeType}');
//           if (message.containsKey('event')) {
//             print(message['event']);
//             if (message['event'] == 'systemStatus' &&
//                 message['status'] == 'online') {
//               print('sub');
//               List<int> subEvent =
//                   _codec.encode({...KrakenEvents['subscribe'], 'pair': _pairs});
//               _channel.sink.add(subEvent);
//             }
//           }
//         }
//       }
//     });
//   }
//
//   static subscribe(List<String> crypto, String currency) {
//     _crypto = crypto;
//     _currency = currency;
//
//     _crypto.forEach((element) {
//       _pairs.add('$element/$_currency');
//     });
//   }
//
//   static unsubscribe() {
//     _initialize();
//     print('subscribed');
//     List<int> event = _codec.encode({
//       ...KrakenEvents['unsubscribe'],
//       'pair': ["BTC/USD"]
//     });
//     _channel.sink.add(event);
//   }
//
//   static stopListening() async {
//     _channel.sink.close(status.goingAway);
//     await _channel.sink.done;
//     _channel = null;
//   }
//
//   static List<String> _generatePairs() {
//     List<String> gen = [];
//
//     return gen;
//   }
//
//   static _handleSocketMessages() {}
// }
