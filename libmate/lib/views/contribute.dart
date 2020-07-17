import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libmate/views/drawer.dart';

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  final _formKey = GlobalKey<FormState>();

  String barcode = "";

  Future _scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException catch (e) {
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
    var barcodeText = TextFormField(
        decoration: InputDecoration(
            labelText: "Barcode value",
            suffixIcon: new IconButton(onPressed: () async {
              await _scanBarcode();
            }, icon: Icon(Icons.camera))
        ),
        validator: (String value) {
          RegExp re = new RegExp(r"^\d+$");
          return value == null || !re.hasMatch(value)
              ? "Value incorrect"
              : null;
        },
        initialValue: this.barcode
    );

    var bookText = SimpleTextField(hint: "Book name");

    var submitBtn = RaisedButton(
      onPressed: () {
        // Validate returns true if the form is valid, otherwise false.
        if (_formKey.currentState.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.

          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('Processing Data')));
        }
      },
      child: Text('Submit'),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Contribute Page'),
      ),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            barcodeText,
            bookText,
            submitBtn
          ],
        ),
      ),
    );
  }
}

class SimpleTextField extends StatelessWidget {
  String hint;
  SimpleTextField({this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: this.hint,
        ),
        validator: (String value) {
          return value == null ? "Value incorrect" : null;
        },
        initialValue: ""
    );
  }
}
