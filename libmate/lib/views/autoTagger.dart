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

class AutoTaggerPage extends StatefulWidget {
  @override
  _AutoTaggerPageState createState() => _AutoTaggerPageState();
}

class _AutoTaggerPageState extends State<AutoTaggerPage> {
  final _formKey = GlobalKey<FormState>();

  final _isbnController = TextEditingController();
  final _nameController = TextEditingController();
  final _authorsController = TextEditingController();
  final _publisherController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _genreController = TextEditingController();
  String _image = defImage;

  void cleanFields() {
    _isbnController.text = "";
    _nameController.text = "";
    _authorsController.text = "";
    _publisherController.text = "";
    _subjectController.text = "";
    _descriptionController.text = "";
    _genreController.text = "";
  }

  Future<String> _sendRequest() async {
    try {
      if(_nameController.text == "") {
        await _autofill();
      }
      final snapShot = await Firestore.instance
          .collection("books")
          .document(_isbnController.text)
          .get();
      Map<dynamic, dynamic> map = Map<dynamic, dynamic>();
      if (!snapShot.exists) {
        map['1'] = 'available';
        Firestore.instance
            .collection("books")
            .document(_isbnController.text)
            .setData({
          'author': _authorsController.text,
          'description': _descriptionController.text,
          'genre': _genreController.text,
          'image': _image,
          'name': _nameController.text,
          'subject': _subjectController.text,
          'issues': map,
        });
      } else {
        map.addAll(snapShot.data['issues']);
        String field = '1';
        snapShot.data['issues'].forEach((key, value) {
          if (key.compareTo(field) == 0) {
            field = (int.parse(field) + 1).toString();
          }
        });
        map[field] = 'available';

        Firestore.instance
            .collection("books")
            .document(_isbnController.text)
            .updateData({
          'author': _authorsController.text,
          'description': _descriptionController.text,
          'genre': _genreController.text,
          'image': _image,
          'name': _nameController.text,
          'subject': _subjectController.text,
          'issues': map,
        });

        cleanFields();
      }
    } catch (e) {
      return "Error sending request!!";
    }
    return "hello";
  }

  Future<String> _autofill() async {
    var raw = await http.get(
        'https://www.googleapis.com/books/v1/volumes?q=${_isbnController.text}&maxResults=1');
    var data = jsonDecode(raw.body);
    if (data['totalItems'] == 0 || data['items'].length == 0) {
      return "Book Not Found!!";
    }
    data = data['items'][0]['volumeInfo'];
    String text = "";

    _nameController.text = data['title'];
    text += _nameController.text;

    _authorsController.text = "";
    if (data['authors'] != null) {
      for (var author in data['authors']) {
        _authorsController.text += author + "; ";
      }
      _authorsController.text = _authorsController.text
          .substring(0, _authorsController.text.length - 2);
      text += " " + _authorsController.text;
    }

    _publisherController.text = "";
    if (data['publisher'] != null) {
      _publisherController.text = data['publisher'];
    }

    _descriptionController.text = "";
    if (data['description'] != null) {
      _descriptionController.text = data['description'];
      text += " " + _descriptionController.text;
    }

    var res = await http.get('http://54.226.130.180/predict?text=${text}');

    var gen = res.body;

    _subjectController.text = gen.split(';')[0] ?? "";

    _genreController.text = gen.split(';')[1] ?? "";

    _image = defImage;
    if (data['imageLinks'] != null && data['imageLinks']['thumbnail'] != null) {
      _image = data['imageLinks']['thumbnail'];
    }

    return "Auto Tagged!";
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
        title: new Text('Auto Tagger Page'),
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
                          decoration:
                              InputDecoration(hintText: "Name of the Book"),
                          controller: _nameController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Authors of the Book"),
                          controller: _authorsController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Genre of the Book"),
                          controller: _genreController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Subject of the Book"),
                          controller: _subjectController,
                          validator: (value) {
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Publisher of the Book"),
                          controller: _publisherController,
                          validator: (value) {
                            return null;
                          },
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
                                    showToast(context, "Sending Request..");
                                    final String resp = await _sendRequest();
                                    showToast(context, resp);
                                  }
                                },
                                child: Text(
                                  'Add Book',
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
                                  'Auto Tag',
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
