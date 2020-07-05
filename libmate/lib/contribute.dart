import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import './drawer.dart';

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  String barcode = "";

  Future _scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() { this.barcode = barcode; });
    } on PlatformException catch(e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Camera Permission Not Granted';
        });
      } else {
        setState(() {
          this.barcode = 'Unknown Error: $e';
        });
      }
    } on FormatException {
      setState(() {
        this.barcode = 'User pressed the Back Button';
      });
    } catch (e) {
      setState(() {
        this.barcode = 'Unknown Error $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Contribute Page'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'The read in BarCode is:',
            ),
            Text('$barcode',
                style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanBarcode,
      ),
    );
  }
}
