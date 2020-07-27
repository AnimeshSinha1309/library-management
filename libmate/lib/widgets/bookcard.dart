import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/toread.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCard extends StatelessWidget {
  final BookModel model;
  bool shouldOpenPage;

  BookCard({@required this.model, this.shouldOpenPage = true})
      : super(key: UniqueKey()) {}

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: SizedBox(
          height: 250,
          width: 150,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.image),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FractionallySizedBox(
                  heightFactor: 0.6,
                  widthFactor: 1.0,
                  child: Material(
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      splashColor: Colors.white,
                      onTap: () {
                        if (shouldOpenPage)
                          gotoPage(context, BookPage(model: model));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Color.fromRGBO(0, 0, 0, 0.9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              model.name ?? "",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              model.author ?? "",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Genre: " + model.genre ?? "",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        ));
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
    rbook.book = model.name ?? "";
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
