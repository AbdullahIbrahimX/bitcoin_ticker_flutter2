import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

const Map<String, Map> KrakenEvents = {
  'subscribe': {
    "event": "subscribe",
    "subscription": {"name": "ticker"}
  },
  'unsubscribe': {
    "event": "unsubscribe",
    "subscription": {"name": "ticker"}
  }
};

class KrakenWS {
  static IOWebSocketChannel _channel;
  static Stream _stream;
  static String _uri = 'wss://ws.kraken.com';
  static List<String> _cryptoPairs = [];
  static var _codec = new JsonCodec().fuse(new Utf8Codec());
  static Map<String, List<dynamic>> _coinDisplayData = {};

  static subscribeToPairs(String currency, List<String> cryptoList) {
    _init();
    //TODO add take(2);
    _stream.listen((event) {
      dynamic message = jsonDecode(event);

      if (message != null &&
          message is! List<dynamic> &&
          message.containsKey('event')) {
        if (message['event'] == 'systemStatus' &&
            message['status'] == 'online') {
          subscribeAll(currency, cryptoList);
        }
      }
      print(message);
    });
  }

  static subscribeAll(String currency, List<String> cryptoList) {
    for (String crypto in cryptoList) {
      _cryptoPairs.add('$crypto/$currency');
    }
    List<int> subEvent =
        _codec.encode({...KrakenEvents['subscribe'], 'pair': _cryptoPairs});
    _channel.sink.add(subEvent);
  }

  static unsubscribeAll() {
    List<String> unsubList = [];
    _coinDisplayData.forEach((key, value) {
      if (value.last) {
        unsubList.add(key);
      }
    });

    List<int> unsubEvent =
        _codec.encode({...KrakenEvents['unsubscribe'], 'pair': unsubList});
    _channel.sink.add(unsubEvent);
    _cryptoPairs = [];
    _coinDisplayData.clear();
  }

  static closeConnection() async {
    _channel.sink.close();
  }

  static listenToCoinErrors() async {
    Stream stream = _stream.where((event) => jsonDecode(event) is! List);

    await for (String errorPrePayload in stream) {
      Map errorPayload = jsonDecode(errorPrePayload);
      if (errorPayload['event'] == 'subscriptionStatus' &&
          errorPayload['status'] == 'error') {
        String pairName = errorPayload['pair'];
        String errorMessage = errorPayload['errorMessage'];
        _coinDisplayData[pairName] = [errorMessage, false];
      }
    }
  }

  static Stream<Map<String, List<dynamic>>> listenToCoinPrices() async* {
    Stream stream =
        _stream.where((event) => jsonDecode(event) is List<dynamic>);

    await for (String coinPrePayload in stream) {
      List coinPayload = jsonDecode(coinPrePayload);
      Map coinData = coinPayload[1];
      double closePrice = double.parse(coinData['c'][0]);
      String closeVolume = coinData['c'][1];
      double openPrice = double.parse(coinData['o'][0]);
      String pairName = coinPayload.last.toString();
      double prevClosePrice = _coinDisplayData[pairName] == null
          ? 0.0
          : _coinDisplayData[pairName][0];

      double changeAmount = closePrice - prevClosePrice;
      double OAchangePercentage =
          (100 * ((closePrice - openPrice) / openPrice));

      _coinDisplayData[pairName] = [
        closePrice,
        closeVolume,
        openPrice,
        pairName,
        changeAmount,
        OAchangePercentage,
        _compare(closePrice, prevClosePrice),
        _compare(closePrice, openPrice),
        true
      ];
      print(_coinDisplayData);
      yield _coinDisplayData;
    }
  }

  static Color _compare(double number1, double number2) {
    if (number1 > number2) {
      return Colors.green;
    } else if (number1 < number2) {
      return Colors.redAccent;
    } else {
      return Colors.white;
    }
  }

  static _init() {
    if (_channel != null) return;

    _channel = IOWebSocketChannel.connect(Uri.parse(_uri),
        pingInterval: Duration(seconds: 4));

    _stream = _channel.stream.asBroadcastStream();
  }
}
