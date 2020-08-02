import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'dart:convert';
import 'package:qrscan/qrscan.dart' as scanner;

class IssueBook extends StatefulWidget {
  @override
  createState() => IssueBookState();
}

class IssueBookState extends State<IssueBook> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  List<BookModel> books;

  Future _scanBarcode() async {
    try {
      String barcode = await scanner.scan();
      setState(() {
        try {
          List<dynamic> val = jsonDecode(barcode);
          setState(() {
            email = val[0];
            for (int i = 1; i < val.length; i++) {
              books.add(BookModel.fromJSON(json: val[1]));
            }
            print(email);
            print(books);
          });
        } catch (err) {
          print("Invalid barcode");
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var btn = RaisedButton.icon(
        onPressed: () async {
          print("doing");
          await _scanBarcode();
        },
        icon: Text("Scan QR code"),
        label: Icon(Icons.camera));

    List<Widget> bookWidgs = [];

    if (books != null)
      books.forEach((book) {
        bookWidgs.add(BookCard(model: book));
      });

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Issue student book")),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: SafeArea(
              left: true,
              right: true,
              top: true,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                        ButtonTheme(
                            textTheme: ButtonTextTheme.primary, child: btn),
                        Text("User detected: $email")
                      ] +
                      bookWidgs),
            )));
  }
}
