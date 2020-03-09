import 'package:flutter/material.dart';

import './drawer.dart';

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
//  Future _scanBarcode() async {
//    String barcode = await FlutterBarcodeScanner.scanBarcode(
//        '#000000', 'Cancel', true, ScanMode.BARCODE);
//    return barcode;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Contribute Page'),
      ),
      drawer: AppDrawer(),
//      floatingActionButton: FloatingActionButton.extended(
//        icon: Icon(Icons.camera_alt),
//        label: Text("Scan"),
//        onPressed: _scanBarcode,
//      ),
    );
  }
}
