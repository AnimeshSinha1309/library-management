import 'package:flutter/material.dart';
import 'package:libmate/widgets/requested.dart';
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
    final double height = 180;

    return Card(
      elevation: 5,
      child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white,
          onTap: () {
            if (shouldOpenPage)
              gotoPage(
                  context,
                  BookPage(
                    model: model,
                    removeBook: removeBook,
                  ));
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
                    SizedBox(height: 20),
                    Text(
                      "ISBN: " + model.isbn,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Subject: " + model.subject,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Request Count: " + model.cnt.toString(),
                      style: TextStyle(
                        color: Colors.white,
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
  final RequestedBookModel model;
  final ValueChanged<RequestedBookModel> removeBook;

  BookPage({@required this.model, @required this.removeBook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Requested Book"),
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          RequestedBookCard(model: model),
          SizedBox(height: 10),
          Text('Reason: ' + model.reason,
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2.0,
              )),
          SizedBox(height: 20),
          RaisedButton.icon(
            onPressed: () {
              removeBook(model);
            },
            color: Colors.amber,
            icon: Icon(Icons.remove_shopping_cart),
            label: Text('Remove'),
          ),
        ]));
  }
}
