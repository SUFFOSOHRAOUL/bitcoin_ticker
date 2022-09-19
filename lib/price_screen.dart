import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  late Future<CoinData> futureCoindata;
  String SelectedCurrency = 'USD';
  @override
  DropdownButton androidPicker() {
    List<DropdownMenuItem<String>> DropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      DropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: SelectedCurrency,
      items: DropdownItems,
      onChanged: (value) {
        setState(() {
          SelectedCurrency = value!;
        });
      },
    );
  }

  CupertinoPicker pickerItem() {
    List<Widget> pickerItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newPickerItems = Text(currency);
      pickerItems.add(newPickerItems);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 35.0,
      onSelectedItemChanged: (SelectedIndex) {
        print(SelectedIndex);
      },
      children: pickerItems,
    );
  }

  Widget addCard() {
    List<Widget> currency_Cards = [];
    var exchangeCard;
    for (int i = 0; i < cryptoList.length; i++) {
      String crypto = cryptoList[i];

      exchangeCard = Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: FutureBuilder<CoinData>(
                future: futureCoindata,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '1 ${crypto} = ${snapshot.data!.rate} ${SelectedCurrency}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return Text('${snapshot.error}');
                  }
                }),
          ),
        ),
      );
      currency_Cards.add(exchangeCard);
    }

    return ListBody(
      children: currency_Cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    futureCoindata = fetchCoinData(SelectedCurrency);
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          addCard(),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? pickerItem() : androidPicker()),
        ],
      ),
    );
  }
}

Future<CoinData> fetchCoinData(String SelectedCurrency) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/BTC/${SelectedCurrency}?apikey=346D3CF2-28C7-49F2-88B8-82E68EADF806'),
  );
  if (response.statusCode == 200) {
    return CoinData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('failed to load coin data');
  }
}

class CoinData {
  double rate;
  String asset_id_base;
  String asset_id_quote;
  CoinData(
      {required this.rate,
      required this.asset_id_base,
      required this.asset_id_quote});

  factory CoinData.fromJson(Map<String, dynamic> json) {
    return CoinData(
        rate: json['rate'],
        asset_id_base: json['asset_id_base'],
        asset_id_quote: json['asset_id_quote']);
  }
}
