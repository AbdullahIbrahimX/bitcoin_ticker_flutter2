import 'package:bitcoin_ticker_flutter2/services/constants.dart';
import 'package:bitcoin_ticker_flutter2/services/networking.dart';

class CoinData {
  List<dynamic> _rateList = [];

  Future<List<Map<String, dynamic>>> getCoinData({currency: String}) async {
    NetworkHelper networkHelper = NetworkHelper(
      website: "rest.coinapi.io",
      path: "/v1/exchangerate/USD",
      headers: {"X-CoinAPI-Key": kAPIKey},
      queries: {"filter_exchange_id": cryptoList + currenciesList},
    );
    var coinData = await networkHelper.getData();
    _rateList = coinData["rates"];
    return getAllCryptoRates(currency: currency);
  }

  /// gets only String [currency] like USD,GBP and returns a List [results]  of Map objects each represents a
  /// crypto or a currency,
  /// each Map object has two values [Crypto] which is the cryptocurrency's name like BTC,XRP
  /// and [rate] the of the crypto to the desired currency
  ///
  List<Map<String, dynamic>> getAllCryptoRates({currency: String}) {
    List<Map<String, dynamic>> results = [];
    cryptoList.forEach((e) {
      results.add({
        "Crypto": e,
        "rate": getRate(currencyID: currency, cryptoID: e).toStringAsFixed(4),
      });
    });
    return results;
  }

  double getRate({currencyID: String, cryptoID: String}) {
    var currency;
    var crypto;

    if (currencyID == "USD") {
      crypto = _rateList
          .firstWhere((element) => element["asset_id_quote"] == cryptoID);
      return 1 / crypto["rate"];
    } else {
      currency = _rateList
          .firstWhere((element) => element["asset_id_quote"] == currencyID);
      crypto = _rateList
          .firstWhere((element) => element["asset_id_quote"] == cryptoID);
      double rate = currency["rate"] * (1 / crypto["rate"]);
      return rate;
    }
  }
}
