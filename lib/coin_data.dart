import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = 'AC152EEF-1224-4380-AD8A-5D88C052FFBF';

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
  Future getCoinData(currency) async {
    Map<String, String> cryptoPrice = {};
    for (String crypto in cryptoList) {
      var response = await http.get(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$currency?apikey=$apiKey');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        cryptoPrice[crypto] = data['rate'].toStringAsFixed(0);
      } else
        print(response.statusCode);
    }
    return cryptoPrice;
  }
}
