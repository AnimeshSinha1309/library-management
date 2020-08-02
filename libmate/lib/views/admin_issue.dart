import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:libmate/widgets/issueitem.dart';
import 'dart:convert';
import 'package:qrscan/qrscan.dart' as scanner;

class IssueBook extends StatefulWidget {
  @override
  createState() => IssueBookState();
}

class IssueBookState extends State<IssueBook> {
  String email = "";
  List<BookModel> books;
  List<BorrowBookModel> returns;

  Future _scanBarcode() async {
    try {
      String barcode = await scanner.scan();
      // String barcode = '["animeshsinha.1309@gmail.com",{"name":"Quantum Computation and Quantum Information","author":"Michael Nielsen; Issac Chuang","isbn":"9781139495486","image":"http://books.google.com/books/content?id=-s4DEy7o-a0C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api","subject":"Physics","genre":"Quantum","description":"One of the most cited books in physics of all time, Quantum Computation and Quantum Information remains the best textbook in this exciting field of science. This 10th anniversary edition includes an introduction from the authors setting the work in context. This comprehensive textbook describes such remarkable effects as fast quantum algorithms, quantum teleportation, quantum cryptography and quantum error-correction. Quantum mechanics and computer science are introduced before moving on to describe what a quantum computer is, how it can be used to solve problems faster than \'classical\' computers and its real-world implementation. It concludes with an in-depth treatment of quantum information. Containing a wealth of figures and exercises, this well-known textbook is ideal for courses on the subject, and will interest beginning graduate students and researchers in physics, computer science, mathematics, and electrical engineering."}]';
      setState(() {
        try {
          Map<String, dynamic> val = jsonDecode(barcode);

          setState(() {
            email = val['email'];
            books = val['issues']
                .map<BookModel>((e) => BookModel.fromJSON(json: e));
            returns = val['returns']
                .map<BorrowBookModel>((e) => BorrowBookModel.fromJSON(e));
          });
        } catch (err) {
          print(err);
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

    List<Widget> bookWidgs = [Text("Books being Issued")];
    if (books != null)
      books.forEach((book) {
        bookWidgs.add(BookCard(model: book));
      });
    List<Widget> returnWidgs = [Text("Books being Returned")];
    if (books != null)
      returns.forEach((book) {
        returnWidgs.add(IssuedBookCard(model: book));
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
              child: ListView(
                  children: <Widget>[
                        ButtonTheme(
                            textTheme: ButtonTextTheme.primary, child: btn),
                        Text("User detected: $email")
                      ] +
                      bookWidgs),
            )));
  }
}
