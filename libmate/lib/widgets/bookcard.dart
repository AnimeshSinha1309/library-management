import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/toread.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

Route _createRoute(BookModel model) {
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

class BookCard extends StatelessWidget {
  BookModel model;
  bool shouldOpenPage;

  BookCard({Key key, @required this.model, this.shouldOpenPage})
      : super(key: key) {
    shouldOpenPage = shouldOpenPage ?? false;
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
            if (shouldOpenPage) Navigator.of(context).push(_createRoute(model));
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
  BookModel model;
  final int maxBooks = 20;
  BookPage({@required this.model});

  void saveReadingList(BookModel model) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readlist = prefs.getStringList("readingList") ?? [];
    if(readlist.length > maxBooks) return;
    ToRead rbook = new ToRead();
    rbook.book = model.name;
    rbook.date = new DateFormat("dd/MM").format(DateTime.now()).toString();
    String sbook = json.encode(rbook);
    for(var it = 0, name = sbook.split(',')[0]; it < readlist.length; it++) {
      if(readlist[it].split(',')[0] == name) {
        readlist[it] = sbook;
        prefs.setStringList("readingList", readlist); return;
      }
    }
    readlist.add(sbook);
    prefs.setStringList("readingList", readlist);
  }

  void addBook(BookModel model) {
    saveReadingList(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Book"),
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          BookCard(model: model),
          Text("Copies: available 5, total 10"),
          RaisedButton(
            onPressed: () {
              addBook(model);
            },
            child: Text("Add to reading list"),
          )
        ]));
  }
}
