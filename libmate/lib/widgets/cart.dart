import 'dart:convert';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:libmate/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/checkout.dart';
import 'package:libmate/widgets/issueitem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookCartUI extends StatefulWidget {
  UserModel user;
  BookCartUI(this.user);
  @override
  createState() => BookCartState();
}

class BookCartState extends State<BookCartUI> {
  Set<BookModel> books = Set<BookModel>();
  Set<BorrowBookModel> returns = Set<BorrowBookModel>();
  int numBooks = 0, numReturns = 0;
  bool loaded;

  Future loadState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> templist;
    templist = prefs.getStringList("issuecart") ?? [];
    books = Set<BookModel>();
    for (var book in templist) {
      var dec = json.decode(book);
      books.add(BookModel.fromJSON(json: dec));
    }
    templist = prefs.getStringList("returncart") ?? [];
    returns = Set<BorrowBookModel>();
    for (var book in templist) {
      var dec = json.decode(book);
      returns.add(BorrowBookModel.fromJSON(dec));
    }
    numBooks = books.length;
    numReturns = returns.length;
    setState(() {
      loaded = true;
    });
  }

  void saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "issuecart", books.map((BookModel book) => json.encode(book)).toList());
    prefs.setStringList("returncart",
        returns.map((BorrowBookModel book) => json.encode(book)).toList());
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
    var returnList = returns.toList();
    // print(booklist[0].name);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Your cart")),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) =>
                          IssuedBookCard(model: returnList[index]),
                      childCount: returns == null ? 0 : returnList.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: ButtonTheme(
                          minWidth: 200,
                          textTheme: ButtonTextTheme.primary,
                          child: RaisedButton(
                              child: Text("Checkout"),
                              onPressed: () {
                                gotoPage(
                                    context,
                                    Checkout(
                                        booklist, returnList, widget.user));
                              })))
                ],
              ),
            )));
  }

  dynamic toJSON() {
    var res = [];

    for (var book in books) {
      res.add(book.toJSON());
    }
    for (var book in returns) {
      res.add(book.toJSON());
    }
    return res;
  }
}
