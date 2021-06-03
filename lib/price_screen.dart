import 'coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String curr in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(curr),
        value: curr,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          print(value);
          selectedCurrency = value!;
          getCryptoPrice();
        });
      },
    );
  }
CupertinoPicker IosPicker(){
  List<Text> pickerItems = [];
  for (String currency in currenciesList) {
    var newItem = Text(
      currency,
      style: TextStyle(
        color: Colors.white,
      ),
    );
    pickerItems.add(newItem);
  }

  return CupertinoPicker(
      itemExtent: 45,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
        print(selectedIndex);
        selectedCurrency=currenciesList[selectedIndex] ;
        print(selectedCurrency);
        getCryptoPrice();
        });
      },
      children: pickerItems,
  );
}

Map<String,String> coinValues ={};
  bool isWaiting = false;

void getCryptoPrice() async{
isWaiting = true;
try{
  CoinData coindata = CoinData();
  print("IN GETcryptoPrice " + selectedCurrency);
  var data = await coindata.getCoinData(selectedCurrency);
  isWaiting = false;
  setState(() {
    coinValues = data;
    print(coinValues);
  });
}
catch(e){
  print(e);
}
}

  @override
  void initState(){
    super.initState();
    print("UPDATING UI");
    getCryptoPrice();
  }

Column makeCards(){
  List <cryptoCard> cryptoCards = [];
  for(String crypto in cryptoList){
    String? value = coinValues[crypto];
    print("Value of coinValue[]");
    print(value);
    cryptoCards.add(
      cryptoCard(
        crypto,selectedCurrency, isWaiting ? '?' : value!,
      )
    );
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children : cryptoCards,
  );
}
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('🤑 Coin Ticker'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              makeCards(),
              // SizedBox(
              //   height: 290,
              // ),
              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS? IosPicker(): androidDropdown()
              ),
            ]));
  }
}

class cryptoCard extends StatelessWidget {
  const cryptoCard(
      this.cryptoCurrency,
    this.selectedCurrency,
      this.rateValue,
      );
  final String selectedCurrency;
  final String cryptoCurrency;
  final String rateValue ;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding:
            EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $cryptoCurrency= $rateValue $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
  }
}
