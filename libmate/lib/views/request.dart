import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String defImage =
    "https://www.peterharrington.co.uk/blog/wp-content/uploads/2014/09/shelves.jpg";

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();

  final _isbnController = TextEditingController();
  final _nameController = TextEditingController();
  final _reasonController = TextEditingController();
  String _subject = "";
  String _image = defImage;

  Future<bool> doesExist() async {
    final snapShot = await Firestore.instance
        .collection("books")
        .document(_isbnController.text)
        .get();
    if (snapShot == null || !snapShot.exists) {
      return false;
    }
    return true;
  }

  Future<String> _sendRequest() async {
    final res = await doesExist();
    if (res) {
      return "This book is present in the library";
    }

    try {
      final snapShot = await Firestore.instance
          .collection("requested books")
          .document(_isbnController.text)
          .get();
      if (snapShot == null || !snapShot.exists) {
        if (_nameController.text == "") {
          await _autofill();
        }
        await Firestore.instance
            .collection("requested books")
            .document(_isbnController.text)
            .setData({
          'name': _nameController.text,
          'subject': _subject,
          'reason': _reasonController.text,
          'image': _image,
          'cnt': 1,
        });
      } else {
        String reason = snapShot.data['reason'].length >= _reasonController.text.length
            ? snapShot.data['reason']
            : _reasonController.text;
        await Firestore.instance
            .collection("requested books")
            .document(_isbnController.text)
            .updateData({'cnt': snapShot.data['cnt'] + 1, 'reason': reason});
      }

      _isbnController.text = "";
      _nameController.text = "";
      _reasonController.text = "";
      return "Request Submitted!";
    } catch (e) {
      return "Error sending request!!";
    }
  }

  Future<String> _autofill() async {
    var raw = await http.get(
        'https://www.googleapis.com/books/v1/volumes?q=${_isbnController.text}&maxResults=1');
    var data = jsonDecode(raw.body);
    if (data['totalItems'] == 0 || data['items'].length == 0) {
      return "Book Not Found!!";
    }
    data = data['items'][0]['volumeInfo'];
    _nameController.text = data['title'];
    _subject = "";
    if (data['categories'] != null) {
      for (var catg in data['categories']) {
        _subject += catg + ", ";
      }
      _subject = _subject.substring(0, _subject.length - 2);
    }
    _image = defImage;
    if (data['imageLinks'] != null && data['imageLinks']['thumbnail'] != null) {
      _image = data['imageLinks']['thumbnail'];
    }
    return "Auto Filled!";
  }

  Future _scanBarcode() async {
    try {
      final isbn = await BarcodeScanner.scan();
      if (isISBN(isbn)) {
        _isbnController.text = isbn;
        await _autofill();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Request Page'),
      ),
      drawer: AppDrawer(),
      body: Builder(
          builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "ISBN of the Book",
                              suffixIcon: new IconButton(
                                  onPressed: () async {
                                    await _scanBarcode();
                                  },
                                  icon: Icon(Icons.camera))),
                          controller: _isbnController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the ISBN of the book';
                            } else if (!isISBN(value)) {
                              return 'Please enter the valid ISBN';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          enabled: false,
                          decoration:
                              InputDecoration(hintText: "Name of the Book"),
                          controller: _nameController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Reasons, Cosigners, etc."),
                          controller: _reasonController,
                          minLines: 1,
                          maxLines: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.pinkAccent,
                                onPressed: () async {
                                  // Validate returns true if the form is valid, or false
                                  // otherwise.
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    showToast(context, "Sending Request..");
                                    final String resp = await _sendRequest();
                                    showToast(context, resp);
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 64),
                              RaisedButton(
                                color: Colors.pinkAccent,
                                onPressed: () async {
                                  // Validate returns true if the form is valid, or false
                                  // otherwise.
                                  if (_formKey.currentState.validate()) {
                                    showToast(context, "Fetching Info..");
                                    final String resp = await _autofill();
                                    showToast(context, resp);
                                  }
                                },
                                child: Text(
                                  'Autofill',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              )),
    );
  }
}
