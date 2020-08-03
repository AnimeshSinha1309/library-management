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

  void clearCart() {
    setState(() {
      books = Set();
      returns = Set();
      numBooks = numReturns = 0;
      saveCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    var booklist = books.toList();
    var returnList = returns.toList();

    dynamic btnChild = ButtonTheme(
        minWidth: 200,
        textTheme: ButtonTextTheme.primary,
        child: RaisedButton(
            child: Text("Checkout"),
            onPressed: () {
              gotoPage(context, Checkout(booklist, returnList, widget.user));
            }));
    dynamic clearBtn = ButtonTheme(
        minWidth: 200,
        textTheme: ButtonTextTheme.primary,
        child: RaisedButton(child: Text("Clear cart"), onPressed: clearCart));

    if (booklist.isEmpty && returnList.isEmpty) {
      btnChild = Text("Please add something into your cart first");
      clearBtn = Text(" ");
    }
    dynamic issueBks = SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        // mainAxisSpacing: 10.0,
        // crossAxisSpacing: 10.0,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => BookCard(model: booklist[index]),
        childCount: books == null ? 0 : booklist.length,
      ),
    );
    if (booklist.isEmpty) {
      issueBks = SliverToBoxAdapter(child: Text("No book issued"));
    }
    dynamic returnBks = SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400.0,
        // mainAxisSpacing: 10.0,
        // crossAxisSpacing: 10.0,
        childAspectRatio: 2.25,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) =>
            IssuedBookCard(model: returnList[index]),
        childCount: returns == null ? 0 : returnList.length,
      ),
    );
    if (returnList.isEmpty)
      returnBks = SliverToBoxAdapter(child: Text("No book returned"));

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
                  SliverToBoxAdapter(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text('Books being Issued',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left))),
                  issueBks,
                  SliverToBoxAdapter(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text('Books being Returned',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold)))),
                  returnBks,
                  SliverToBoxAdapter(child: btnChild),
                  SliverToBoxAdapter(child: clearBtn)
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
