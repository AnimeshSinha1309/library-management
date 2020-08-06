import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:libmate/widgets/issueitem.dart';
import 'package:libmate/utils/utils.dart';
import 'dart:convert';
import 'package:qrscan/qrscan.dart' as scanner;

class IssueBook extends StatefulWidget {
  @override
  createState() => IssueBookState();
}

class IssueBookState extends State<IssueBook> {
  String email, name, photoUrl;
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
            name = val['name'];
            photoUrl = val['photo'];

            books = val['issues']
                .map<BookModel>((e) => BookModel.fromJSON(json: e))
                .toList();
            returns = val['returns']
                .map<BorrowBookModel>((e) => BorrowBookModel.fromJSON(e))
                .toList();
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
          print("Doing");
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

    dynamic display;
    print(email);

    if (email != "" && email != null) {
      display = CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(photoUrl ?? "https://i.pravatar.cc/300"),
            ),
            title: Text(name ?? "Libmate Test User"),
            subtitle: Text(email ?? "test@libmate.iiit.ac.in"),
          )),
          SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Books being Issued',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)))),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
                  BookCard(model: books[index]),
              childCount: books == null ? 0 : books.length,
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Books being Returned',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)))),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400.0,
              childAspectRatio: 2.25,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
                  IssuedBookCard(model: returns[index]),
              childCount: returns == null ? 0 : returns.length,
            ),
          ),
          SliverToBoxAdapter(
              child: ButtonTheme(
                  minWidth: 200,
                  textTheme: ButtonTextTheme.primary,
                  child: RaisedButton(
                      child: Text("Permit Transaction"),
                      onPressed: () async {
                        await Future.delayed(Duration(seconds: 2));
                        gotoPage(context, null,
                            clear: true, routeName: "/admin_scan");
                      })))
        ],
      );
    } else
      display = btn;

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Issue student book")),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: SafeArea(
              left: true,
              right: true,
              top: true,
              child: display,
            )));
  }
}
