import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropdownValue = 'USD';

  DropdownButton<String> androidDropdown() => DropdownButton<String>(
        value: dropdownValue,
        onChanged: (value) {
          setState(() {
            if (value != dropdownValue) {
              dropdownValue = value;
              getExchangeRate(dropdownValue);
            }
          });
        },
        items: currenciesList
            .map((value) => DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                ))
            .toList(),
      );

  CupertinoPicker iOSPicker() => CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: currenciesList
            .map(
              (value) => Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            )
            .toList(),
      );

  bool waiting = false;
  Map coinValues = {};

  void getExchangeRate(currency) async {
    waiting = true;
    try {
      var data = await CoinData().getCoinData(currency);
      waiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> getCards() => cryptoList
      .map(
        (coin) => CryptoCard(
            cryptoCurrency: coin,
            cryptoValue: waiting ? '?' : coinValues[coin],
            dropdownValue: dropdownValue),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    getExchangeRate(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard(
      {@required this.cryptoCurrency,
      @required this.cryptoValue,
      @required this.dropdownValue});

  final String cryptoValue;
  final String dropdownValue;
  final String cryptoCurrency;

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
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $cryptoCurrency = $cryptoValue $dropdownValue',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
