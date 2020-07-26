import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/model.dart';

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
  var imageUrl = "";

  Future _fillInfo() async {
    String isbn = _barcodeController.text;
    var raw = await http.get(
        'https://www.googleapis.com/books/v1/volumes?q=$isbn&maxResults=1');
    var data = json.decode(raw.body);

    setState(() {
      if (data['items'].length == 0) return;

      var book = data['items'][0];
      var bookdata = book['volumeInfo'];

      _titleController.text = bookdata['title'];
      _authorController.text = (bookdata['authors']).join('; ');
      _descriptionController.text = bookdata['description'];

      if (bookdata['imageLinks'] != null &&
          bookdata['imageLinks']['thumbnail'] != null) {
        imageUrl = bookdata['imageLinks']['thumbnail'];
      }
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
          suffixIcon: new IconButton(
              onPressed: () async {
                await _scanBarcode();
                await _fillInfo();
              },
              icon: Icon(Icons.camera))),
      validator: (String value) {
        RegExp re = new RegExp(r"^\d{13}$");
        return value == null || !re.hasMatch(value) ? "Value incorrect" : null;
      },
      keyboardType: TextInputType.number,
    );
    var accNoText = TextFormField(
      controller: _accNoController,
      decoration: InputDecoration(
        labelText: "Accession Number",
      ),
      validator: (String value) {
        RegExp re = new RegExp(r"^[0-9]+$");
        return value == null || !re.hasMatch(value) ? "Value incorrect" : null;
      },
      keyboardType: TextInputType.number,
    );
    var authorText = TextFormField(
      controller: _authorController,
      decoration: InputDecoration(
        labelText: "Author",
      ),
    );
    var bookText = TextFormField(
        decoration: InputDecoration(
          labelText: "Book Name",
        ),
        controller: _titleController);
    var descriptionText = TextFormField(
        decoration: InputDecoration(
          labelText: "Description",
        ),
        minLines: 1,
        maxLines: 4,
        controller: _descriptionController);

    var submitBtn = RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          try {
            Firestore.instance
                .collection("books")
                .document(_barcodeController.text)
                .setData({
              'name': _titleController.text,
              'authors': _authorController.text,
              'description': _descriptionController.text,
              'accNo':
                  FieldValue.arrayUnion([int.parse(_accNoController.text)]),
            }, merge: true);
          } catch (e) {
            print(e.toString());
          }
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
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeInImage(
                  image: NetworkImage(imageUrl),
                  placeholder: NetworkImage(defImage),
                  height: 100),
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
