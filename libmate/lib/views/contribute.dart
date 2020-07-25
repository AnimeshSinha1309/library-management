import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libmate/views/drawer.dart';

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  final _formKey = GlobalKey<FormState>();

  final _barcodeController = TextEditingController();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _accNoController = TextEditingController();

  Future _fillInfo() async {
    String isbn = _barcodeController.text;
    var raw = await http.get(
        'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&maxResults=1');
    var data = json.decode(raw.body);
    setState(() {
      _titleController.text = data['items'][0]['volumeInfo']['title'];
      _authorController.text =
          (data['items'][0]['volumeInfo']['authors']).join('; ');
      _descriptionController.text =
      data['items'][0]['volumeInfo']['description'];
    });
  }

  Future _scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        _barcodeController.text = barcode;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var barcodeText = TextFormField(
      controller: _barcodeController,
      decoration: InputDecoration(
          labelText: "Barcode value",
          suffixIcon: new IconButton(onPressed: () async {
            await _scanBarcode();
            await _fillInfo();
          }, icon: Icon(Icons.camera))
      ),
      validator: (String value) {
        RegExp re = new RegExp(r"^\d+$");
        return value == null || !re.hasMatch(value)
            ? "Value incorrect"
            : null;
      },
    );
    var accNoText = TextFormField(
      controller: _accNoController,
      decoration: InputDecoration(labelText: "Accession Number",),
      validator: (String value) {
        RegExp re = new RegExp(r"^[0-9]+$");
        return value == null || !re.hasMatch(value)
            ? "Value incorrect"
            : null;
      },
    );
    var authorText = TextFormField(
      controller: _authorController,
      decoration: InputDecoration(labelText: "Author",),
    );
    var bookText = TextFormField(
        decoration: InputDecoration(labelText: "Book Name",),
        controller: _titleController
    );
    var descriptionText = TextFormField(
        decoration: InputDecoration(labelText: "Description",),
        controller: _descriptionController
    );

    var submitBtn = RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          try {
            Firestore.instance
                .collection("books")
                .document()
                .setData({
              'name': _titleController,
              'authors': _authorController,
              'description': _descriptionController,
              'isbn': _barcodeController,
              'accNo': _accNoController,
            }, merge: true);
          } catch (e) {
            print(e.toString());
          }

          Scaffold
              .of(context)
              .showSnackBar(
              SnackBar(content: Text('Book Datails have been Updated')));
        }
      },
      child: Text('Submit'),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Contribute Page'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              accNoText,
              barcodeText,
              bookText,
              authorText,
              descriptionText,
              submitBtn
            ],
          ),
        ),
      ),
    );
  }
}