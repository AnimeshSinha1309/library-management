import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Checkout extends StatelessWidget {
  String data;
  Checkout(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Issue book")),
        body: Column(children: [
          QrImage(data: data, version: Qrversions.auto, size: 200.0),
          RaisedButton(
              child: Text("Checkout"),
              onPressed: () {
                String data = jsonEncode(toJSON());
                gotoPage(context, Checkout(data));
              })
        ]));
  }
}
