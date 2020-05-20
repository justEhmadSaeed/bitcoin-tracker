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
    var response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=$apiKey');
    if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
      return data['rate'];
    } else
      print(response.statusCode);
  }
}
