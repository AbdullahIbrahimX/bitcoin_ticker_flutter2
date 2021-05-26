import 'package:web_socket_channel/io.dart';

class KrackenWS {
  static String _uri = 'wss://ws.kraken.com';
  static IOWebSocketChannel _channel;

  static _initialize() {
    print('initialized');
    if (_channel != null) return;
    _channel = IOWebSocketChannel.connect(Uri.parse(_uri));
  }

  static subscribe(String crypto, String currency) {
    print('subscribed');
    _initialize();

    _channel.stream.listen((event) {
      print(event);
      _channel.sink.add({
        "event": "subscribe",
        "pair": ["BTC/USD"],
        "subscription": {"name": "trade"}
      });
    });
  }

  static start() {
    _initialize();
  }
}
