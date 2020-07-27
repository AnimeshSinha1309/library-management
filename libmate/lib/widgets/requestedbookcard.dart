import 'package:flutter/material.dart';
import 'package:libmate/widgets/request.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/utils/utils.dart';

class RequestedBookCard extends StatelessWidget {
  final RequestedBookModel model;
  bool shouldOpenPage;
  final ValueChanged<RequestedBookModel> removeBook;

  RequestedBookCard(
      {Key key, @required this.model, this.removeBook, this.shouldOpenPage})
      : super(key: key) {
    this.shouldOpenPage = shouldOpenPage ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = 200;

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
              flex: 3,
              child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(model.image),
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: height,
                padding: EdgeInsets.all(8),
                color: Color.fromRGBO(100, 100, 100, 0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Name: " + model.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "ISBN: " + model.isbn,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Subject: " + model.subject,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Reason: " + model.reason,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Request Count: " + model.count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Divider(),
                    RaisedButton.icon(
                      onPressed: () {
                        removeBook(model);
                      },
                      color: Colors.amber,
                      icon: Icon(Icons.remove_shopping_cart),
                      label: Text('Remove'),
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
  final RequestedBookModel model;

  void markBook(String uid) {}

  BookPage({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Requested Book"),
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          RequestedBookCard(model: model),
          Spacer(),
          RaisedButton(
            onPressed: () {
              markBook(model.uid);
              print("Approved");
            },
            child: Text("Approve"),
          ),
        ]));
  }
}
