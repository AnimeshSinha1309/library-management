import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';

class Checkout extends StatelessWidget {
  String data;
  Checkout(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Issue book")),
        body: Column(children: [
          QrImage(data: data, version: QrVersions.auto, size: 200.0),
        ]));
  }
}
