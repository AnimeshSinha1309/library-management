import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/toread.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  bool loaded;
  String key = "readingList";
  Set<ToRead> books = Set<ToRead>();
  int numBooks = 0;

  Future<Set<ToRead>> loadReadingList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readlist = prefs.getStringList(key) ?? [];
    Set<ToRead> booklist = Set<ToRead>();
    for (var book in readlist) {
      booklist.add(ToRead.fromJson(json.decode(book)));
    }
    return booklist;
  }

  void saveReadingList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        key, books.map((ToRead book) => json.encode(book)).toList());
  }

  void loadState() async {
    books = await loadReadingList();
    numBooks = books.length;
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loaded = false;
    loadState();
    // books.add(ToRead(book: "Three men in a Boat", date: "28/7"));
    // numBooks = books.length;
    // saveReadingList();
  }

  void addBook(ToRead book) {
    setState(() {
      books.add(book);
      numBooks += 1;
    });
    saveReadingList();
  }

  void removeBook(ToRead book) {
    setState(() {
      books.remove(book);
      numBooks -= 1;
    });
    saveReadingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Goals'),
        ),
        drawer: AppDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Row(children: <Widget>[
                    Icon(
                      Icons.bookmark,
                      color: Colors.grey[400],
                    ),
                    Text('To Read :',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0,
                        )),
                    SizedBox(height: 10.0),
                    Text('$numBooks',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0,
                        )),
                  ]),
                  SizedBox(height: 30.0),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: books.map((b) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text("${b.book} : ${b.date}"),
                              ),
                              RaisedButton.icon(
                                onPressed: () {
                                  removeBook(b);
                                },
                                color: Colors.amber,
                                icon: Icon(Icons.remove_shopping_cart),
                                label: Text('Remove'),
                              ),
                            ]);
                      }).toList()),
                  SizedBox(height: 30.0),
                ])));
  }
}
