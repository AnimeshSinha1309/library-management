import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:libmate/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookCartUI extends StatefulWidget {
  UserModel user;
  BookCartUI(this.user);
  @override
  createState() => BookCartState();
}

class BookCartState extends State<BookCartUI> {
  Set<BookModel> books = Set<BookModel>();
  final String key = "issuecart";
  int numBooks = 0;
  bool loaded;

  Future<Set<BookModel>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readlist = prefs.getStringList(key) ?? [];
    Set<BookModel> booklist = Set<BookModel>();
    for (var book in readlist) {
      var dec = json.decode(book);
      booklist.add(BookModel.fromJSON(json: dec));
    }
    return booklist;
  }

  void saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        key, books.map((BookModel book) => json.encode(book)).toList());
  }

  void loadState() async {
    books = await loadCart();
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
  }

  void removeBook(BookModel book) {
    setState(() {
      books.remove(book);
      numBooks -= 1;
    });
    saveCart();
  }

  @override
  Widget build(BuildContext context) {
    var booklist = books.toList();
    // print(booklist[0].name);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Your cart")),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: SafeArea(
              left: true,
              right: true,
              child: SafeArea(
                  left: true,
                  right: true,
                  top: true,
                  child: CustomScrollView(
                    slivers: [
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) =>
                              BookCard(model: booklist[index]),
                          childCount: books == null ? 0 : booklist.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: ButtonTheme(
                              minWidth: 200,
                              textTheme: ButtonTextTheme.primary,
                              child: RaisedButton(
                                  child: Text("Checkout"),
                                  onPressed: () {
                                    gotoPage(context,
                                        Checkout(booklist, widget.user));
                                  })))
                    ],
                  )),
            )));
  }

  dynamic toJSON() {
    var res = [];

    for (var book in books) {
      res.add(book.toJSON());
    }

    return res;
  }
}
