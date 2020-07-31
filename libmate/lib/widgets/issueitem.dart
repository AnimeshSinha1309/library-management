import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/razorpay.dart';

class IssuedBookCard extends StatelessWidget {
  final BorrowBookModel model;
  final bool shouldOpenPage;

  IssuedBookCard({@required this.model, this.shouldOpenPage = true})
      : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white,
          onTap: () {
            if (shouldOpenPage) gotoPage(context, BookPage(model: model));
          },
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(model.book.image),
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

class BookPage extends StatelessWidget {
  final BorrowBookModel model;

  BookPage({@required this.model});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Center(
        child: ButtonTheme(
          textTheme: ButtonTextTheme.primary,
          child: RaisedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.launch),
            label: Text('Return'),
          ),
        ),
      ),
      Center(
          child: ButtonTheme(
            textTheme: ButtonTextTheme.primary,
            child: RaisedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.swap_horiz),
              label: Text('Re-issue'),
            ),
          )),
    ];

    var finePayBtn = Center(
      child: ButtonTheme(
          child: RaisedButton.icon(
        icon: Icon(Icons.launch),
        label: Text('Pay fine'),
        onPressed: () {
          gotoPage(context, RazorPayPage(model.fine));
        },
          )),
    );

    if (model.fine > 0) children.insert(0, finePayBtn);

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
                "Total fine is \u20B9 " + model.fine.toString(),
                style: TextStyle(fontSize: 20.0),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Text(
                "Book is due on " +
                    model.dueDate.day.toString() +
                    "/" +
                    model.dueDate.month.toString() +
                    "/" +
                    model.dueDate.year.toString(),
                style: TextStyle(fontSize: 20.0),
              )),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children)
        ]));
  }
}
