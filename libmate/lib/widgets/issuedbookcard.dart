import 'package:flutter/material.dart';
// import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/issued.dart';
import 'package:libmate/views/drawer.dart';

Route _createRoute(BorrowBookModel model) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BookPage(model: model),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      });
}

class IssuedBookCard extends StatelessWidget {
  final BorrowBookModel model;

  IssuedBookCard({Key key, @required this.model}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    final double height = 200;
    final today = DateTime.now();
    final fine = today.difference(model.dueDate).inDays * model.fine;

    return Card(
      elevation: 5,
      child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white,
          onTap: () {
            Navigator.of(context).push(_createRoute(model));
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
                      model.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      model.author,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Borrowed Date: " + model.borrowDate.toString().split(' ')[0],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Due Date: " + model.dueDate.toString().split(' ')[0],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Pending Fine: " + fine.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Genre: " + model.genre,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "ISBN: " + model.isbn,
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
  final BorrowBookModel model;

  BookPage({@required this.model});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final latedays = today.difference(model.dueDate).inDays;
    final fine = latedays * model.fine;

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Book"),
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          IssuedBookCard(model: model),
          Text("Total fine is $fine"),
          RaisedButton(
            onPressed: () {
              print("Added");
            },
            child: Text("Pay fine"),
          )
        ]));
  }
}
