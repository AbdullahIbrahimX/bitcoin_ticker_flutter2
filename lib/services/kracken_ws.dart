import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

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
  static String _uri = 'wss://ws.kraken.com';
  static IOWebSocketChannel _channel;
  static var codec = new JsonCodec().fuse(new Utf8Codec());

  static _initialize() {
    if (_channel != null) return;
    _channel = IOWebSocketChannel.connect(Uri.parse(_uri));
    _channel.stream.listen((event) {
      print(event);
    });
    print('initialized');
  }

  static subscribe(List<String> crypto, String currency) {
    _initialize();
    List<String> pairs = _generatePairs(crypto, currency);
    print('subscribed');
    List<int> event =
        codec.encode({...KrakenEvents['subscribe'], 'pair': pairs});
    _channel.sink.add(event);
  }

  static unsubscribe() {
    _initialize();
    print('subscribed');
    List<int> event = codec.encode({
      ...KrakenEvents['unsubscribe'],
      'pair': ["BTC/USD"]
    });
    _channel.sink.add(event);
  }

  static startListening() {
    _initialize();
  }

  static stopListening() async {
    _channel.sink.close(status.goingAway);
    await _channel.sink.done;
    _channel = null;
  }

  static List<String> _generatePairs(List<String> crypto, String currency) {
    List<String> gen = [];
    crypto.map((e) => gen.add("$currency/$e"));
    return gen;
  }

  static _handleSocketMessages() {}
}
