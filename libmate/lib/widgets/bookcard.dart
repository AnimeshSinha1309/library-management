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
  final bool shouldOpenPage;

  BookCard({@required this.model, this.shouldOpenPage = true})
      : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    List<Widget> catInfo = [
      Text(
        "Genre: " + (model.genre ?? ""),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ];
    if (model.subject != null && model.subject != model.genre) {
      catInfo.add(Text(
        "Subject: " + (model.subject),
        style: TextStyle(
          color: Colors.white,
        ),
      ));
    }
    return Card(
        elevation: 5,
        child: SizedBox(
          height: 250,
          width: 150,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.image ?? defImage),
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
                                Flexible(
                                  child: Text(
                                    model.name ?? "",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                Flexible(
                                    child: Text(
                                  model.author ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )),
                                Spacer()
                              ] +
                              catInfo,
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
  final BookModel model;
  final int maxBooks = 20;

  BookPage({@required this.model});

  Future<int> saveReadingList(BookModel model) async {
    final key = "readingList";
    final prefs = await SharedPreferences.getInstance();
    List<String> readList = prefs.getStringList(key) ?? [];
    if (readList.length > maxBooks) return 1;

    ToRead rBook = new ToRead();
    rBook.book = model.name ?? "";
    rBook.date = new DateFormat("dd/MM").format(DateTime.now()).toString();

    String sBook = json.encode(rBook);
    bool found = false;
    for (var it = 0, name = sBook.split(',')[0]; it < readList.length; it++) {
      if (readList[it].split(',')[0] == name) {
        readList[it] = sBook;
        found = true;
        break;
      }
    }

    if (!found) readList.add(sBook);

    return (await prefs.setStringList(key, readList)) ? 0 : 2;
  }

  Future<int> saveCart(BookModel model) async {
    final key = "issuecart";
    final prefs = await SharedPreferences.getInstance();
    List<String> issueCart = prefs.getStringList(key) ?? [];
    if (issueCart.length > maxBooks) return 1;

    String sBook = json.encode(model.toJSON());
    bool found = false;
    for (var it = 0, name = sBook.split(',')[0]; it < issueCart.length; it++) {
      if (issueCart[it].split(',')[0] == name) {
        issueCart[it] = sBook;
        found = true;
        break;
      }
    }

    if (!found) issueCart.add(sBook);

    return (await prefs.setStringList(key, issueCart)) ? 0 : 2;
  }

  List<DataRow> _getAccessionTable() {
    List<DataRow> rows = [];
    model.issues.forEach((key, value) {
      rows.add(DataRow(cells: [DataCell(Text(key)), DataCell(Text(value))]));
    });
    return rows;
  }

  Future<String> addBookCart(BookModel model) async {
    int res = await saveCart(model);
    if (res == 0) {
      return "Added to cart";
    } else if (res == 1) {
      return "Exceeded max size of cart";
    } else if (res == 2) {
      return "Error saving cart";
    } else {
      return "Unknown Error";
    }
  }

  Future<String> addBook(BookModel model) async {
    int res = await saveReadingList(model);
    if (res == 0) {
      return "Added to reading list";
    } else if (res == 1) {
      return "Exceeded max size of reading list";
    } else if (res == 2) {
      return "Error saving reading list!";
    } else {
      return "Unknown Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    var copiesData = _getAccessionTable();
    Widget copiesTable;
    if (copiesData.length == 0)
      copiesTable =
          Text("No copies found, you should file a request for the book!");
    else
      copiesTable = DataTable(
        columns: [
          DataColumn(label: Text("Acc.No.")),
          DataColumn(label: Text("Status"))
        ],
        rows: copiesData,
      );

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Book Details"),
        ),
        drawer: AppDrawer(),
        body: Builder(
            builder: (context) => Padding(
                padding: EdgeInsets.all(25),
                child: ListView(children: [
                  Text(
                    model.name,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    Image(
                      image: NetworkImage(model.image),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
                              ButtonTheme(
                                minWidth: 200,
                                textTheme: ButtonTextTheme.primary,
                                child: RaisedButton(
                                  onPressed: () async {
                                    showToast(
                                        context, await addBookCart(model));
                                  },
                                  child: Text("Issue Book"),
                                ),
                              ),
                              ButtonTheme(
                                minWidth: 200,
                                textTheme: ButtonTextTheme.primary,
                                child: RaisedButton(
                                  onPressed: () async {
                                    final String resp = await addBook(model);
                                    showToast(context, resp);
                                  },
                                  child: Text("Add to Read List"),
                                ),
                              ),
                              ButtonTheme(
                                minWidth: 200,
                                textTheme: ButtonTextTheme.primary,
                                child: RaisedButton(
                                  onPressed: () {
                                    showToast(context, "NOT IMPLEMENTED");
                                  },
                                  child: Text("Edit Information"),
                                ),
                              ),
                            ])))
                  ]),
                  SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Subject: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.subject)
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Genre: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.genre)
                        ]),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Authors: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.author)
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "ISBN: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.isbn)
                        ]),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Description: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.description)
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Copies Status",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  copiesTable
                ]))));
  }
}
