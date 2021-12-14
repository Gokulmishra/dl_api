import 'package:http/http.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: Banknotes()));

class Banknotes extends StatelessWidget {
  int variance;
  int skewness;
  int curtosis;
  int entropy;
  Banknotes(
      {Key key, this.variance, this.skewness, this.curtosis, this.entropy})
      : super(key: key);

//METHOD TO PREDICT PRICE
  Future<Banknotes> predictnote(var body) async {
    var client = http.Client();

    var uri = Uri.parse("https://testapidl.herokuapp.com/predict");

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    String jsonString = json.encode(body);

    try {
      print("hi u reached function predict1");
      var resp = await http.post(uri, headers: headers, body: jsonString);
      print("hi u reached function predict2");
      //var resp = await http.get(Uri.parse("https://testapidl.herokuapp.com/predict"));
      print(resp.statusCode);
      if (resp.statusCode == 200) {
        print("hi u reached function predict3");
        print("I am here");
        var result = json.decode(resp.body);
        print(result["prediction"]);
        return result["prediction"];
      }
      print("hi u reached function predict4");
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter variance',
                  ),
                  onChanged: (val) {
                    variance = int.parse(val);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter skewness',
                  ),
                  onChanged: (val) {
                    skewness = int.parse(val);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter cutosis',
                  ),
                  onChanged: (val) {
                    curtosis = int.parse(val);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter entropy',
                  ),
                  onChanged: (val) {
                    entropy = int.parse(val);
                  },
                ),
                // ignore: deprecated_member_use
                ElevatedButton(
//                  color: Colors.blue,
                  onPressed: () async {
                    var body = [
                      {
                        "variance": variance,
                        "skewness": skewness,
                        "curtosis": curtosis,
                        "entropy": entropy,
                      }
                    ];

                    print(body);
                    print("fetched data");
                    var resp = await predictnote(body);
                    _onBasicAlertPressed(context, resp);
                  },

                  child: const Text("Fake/True"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//function from rflutter pkg to display alert
_onBasicAlertPressed(context, resp) {
  Alert(context: context, title: "Prediction", desc: resp).show();
}
