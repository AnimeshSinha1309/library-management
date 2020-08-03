import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/razorpay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssuedBookCard extends StatelessWidget {
  final BorrowBookModel model;
  final bool shouldOpenPage;

  IssuedBookCard({@required this.model, this.shouldOpenPage = true})
      : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    const String defImage =
        "https://rmnetwork.org/newrmn/wp-content/uploads/2011/11/generic-book-cover.jpg";
    return Card(
      elevation: 5,
      child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white,
          onTap: () {
            if (shouldOpenPage) gotoPage(context, BorrowBookPage(model: model));
          },
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(model.book.image ?? defImage),
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            ),
            Expanded(
              flex: 5,
              child: Container(
                height: 135,
                padding: EdgeInsets.all(8),
                color: model.returnDate != null
                    ? Color.fromRGBO(100, 100, 100, 0.9)
                    : Color.fromRGBO(20, 20, 20, 0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      model.book.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      model.book.author,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      model.returnDate == null
                          ? "Due Date: " +
                              model.dueDate.toString().split(' ')[0]
                          : "Issue Date: " +
                              model.borrowDate.toString().split(' ')[0],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      model.fine != 0
                          ? "Pending Fine: " + model.fine.toString()
                          : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}

class BorrowBookPage extends StatelessWidget {
  final BorrowBookModel model;

  BorrowBookPage({@required this.model});

  /// Takes care of saving the Books on return

  final int maxBooks = 20;

  Future<int> saveCart(BorrowBookModel model) async {
    final key = "returncart";
    final prefs = await SharedPreferences.getInstance();
    List<String> returnCart = prefs.getStringList(key) ?? [];
    if (returnCart.length > maxBooks) return 1;

    String accNo = model.accessionNumber;
    for (var issued in returnCart) {
      var js = json.decode(issued);
      if (BorrowBookModel.fromJSON(js).accessionNumber == accNo) {
        return 3;
      }
    }
    returnCart.add(jsonEncode(model.toJSON()));
    return (await prefs.setStringList(key, returnCart)) ? 0 : 2;
  }

  Future<String> addBookCart(BorrowBookModel model) async {
    int res = await saveCart(model);
    if (res == 0) {
      return "Added to cart";
    } else if (res == 1) {
      return "Exceeded max size of cart";
    } else if (res == 2) {
      return "Error saving cart";
    } else if (res == 3) {
      return "Book already present";
    } else {
      return "Unknown Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Center(
          child: ButtonTheme(
        textTheme: ButtonTextTheme.primary,
        child: Builder(builder: (context) {
          return RaisedButton.icon(
              onPressed: () async {
                showToast(context, await addBookCart(model));
              },
              icon: Icon(Icons.launch),
              label: Text('Return'));
        }),
      )),
    ];

    if (model.isReturned()) {
      children = [];
    }

    var finePayBtn = Center(
      child: ButtonTheme(
          textTheme: ButtonTextTheme.primary,
          child: RaisedButton.icon(
            icon: Icon(Icons.launch),
            label: Text('Pay fine'),
            onPressed: () {
              gotoPage(context, RazorPayPage(model.fine));
            },
          )),
    );

    if (model.fine > 0) children.insert(0, finePayBtn);

    String fineText = "Total fine is \u20B9 " + model.fine.toString();
    if (model.isReturned()) {
      fineText = "Fine paid was " + model.fine.toString();
    }
    String dueText = "Book is due on " +
        model.dueDate.day.toString() +
        "/" +
        model.dueDate.month.toString() +
        "/" +
        model.dueDate.year.toString();
    if (model.isReturned()) {
      dueText = "Book was returned on " +
          model.returnDate.day.toString() +
          "/" +
          model.returnDate.month.toString() +
          "/" +
          model.returnDate.year.toString();
    }

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Issued Book"),
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          IssuedBookCard(model: model),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                fineText,
                style: TextStyle(fontSize: 20.0),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Text(
                dueText,
                style: TextStyle(fontSize: 20.0),
              )),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children)
        ]));
  }
}
