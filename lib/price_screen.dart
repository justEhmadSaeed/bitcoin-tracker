import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

const apiKey = 'AC152EEF-1224-4380-AD8A-5D88C052FFBF';

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
  String bitcoinValue = '?';
  void getExchangeRate(currency) async {
    try {
      bitcoinValue = '?';
      double data = await CoinData().getCoinData(currency);
      setState(() {
        bitcoinValue = data.toStringAsFixed(0);
        print(bitcoinValue);
      });
    } catch (e) {
      print(e);
    }
  }

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
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: ReusableCard(
              bitcoinValue: bitcoinValue,
              currency: dropdownValue,
            ),
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

class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.bitcoinValue, this.currency});

  final String bitcoinValue;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 BTC = $bitcoinValue $currency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
