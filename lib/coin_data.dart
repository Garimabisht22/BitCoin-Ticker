import 'package:http/http.dart' as http;
import 'dart:convert';
class CoinData {
 // CoinData();
  //final String url;
  Future getCoinData(String selectedCurrency) async {
    Map<String,String> cryptoPrices = {};
    for (String crypto in cryptoList){
      print("crypto "+ crypto);
      print(selectedCurrency);
      String requestURL =  '$kurl$crypto/$selectedCurrency?apikey=$kapikey';
      print(requestURL);
      http.Response response = await http.get(Uri.parse(requestURL
         ));
      print(response.statusCode);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        double rate = data['rate'];
        print(rate);
        cryptoPrices[crypto] = rate.toStringAsFixed(0);
        print("btaaaadeeeeeeeeeee");
        print(cryptoPrices[crypto]);
      }
      else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
//String selectedCurrency = 'INR';
const String kapikey='857CB0B7-4A58-46CC-A044-7EA32B9BFA2E';
const String kurl = 'https://rest.coinapi.io/v1/exchangerate/';
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
