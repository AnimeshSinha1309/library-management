import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/widgets/toread.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class BookCard extends StatelessWidget {
  final BookModel model;
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

  Future<int> saveReadingList(BookModel model) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readlist = prefs.getStringList("readingList") ?? [];
    if (readlist.length > maxBooks) return 1;

    ToRead rbook = new ToRead();
    rbook.book = model.name;
    rbook.date = new DateFormat("dd/MM").format(DateTime.now()).toString();

    String sbook = json.encode(rbook);
    bool found = false;
    for (var it = 0, name = sbook.split(',')[0]; it < readlist.length; it++) {
      if (readlist[it].split(',')[0] == name) {
        readlist[it] = sbook;
        found = true;
        break;
      }
    }

    if (!found) readlist.add(sbook);

    return (await prefs.setStringList("readingList", readlist)) ? 0 : 2;
  }

  Future<String> addBook(BookModel model) async {
    int res = await saveReadingList(model);
    if (res == 0) {
      return "Added to reading list";
    } else if (res == 1) {
      return "Exceeded max size of reading list";
    } else if (res == 2) {
      return "Error saving reading list!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Book"),
        ),
        drawer: AppDrawer(),
        body: Builder(
            builder: (context) => Column(children: [
                  BookCard(model: model),
                  Text("Copies: available 5, total 10"),
                  RaisedButton(
                    onPressed: () async {
                      final String resp = await addBook(model);
                      showToast(context, resp);
                    },
                    child: Text("Add to reading list"),
                  )
                ])));
  }
}
