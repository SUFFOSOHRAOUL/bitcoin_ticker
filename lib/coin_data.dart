import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getExchangerate() async {
    Uri Url = Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=346D3CF2-28C7-49F2-88B8-82E68EADF806');
    http.Response response = await http.get(Url);
    String coindata = response.body;
    return jsonDecode(coindata);
  }
}
