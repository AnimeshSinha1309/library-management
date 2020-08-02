import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/datastore/model.dart';
import 'dart:convert';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class Checkout extends StatefulWidget {
  String qrdata;
  String uid;
  List<BookModel> books;
  List<BorrowBookModel> returns;
  UserModel user;

  // uid for checking issue status of books
  Checkout(this.books, this.returns, this.user) {
    uid = user.email;
    List<dynamic> booksList = [];
    for (var book in books) {
      booksList.add(book.toJSON());
    }
    List<dynamic> returnList = [];
    for (var book in returns) {
      returnList.add(book.toJSON());
    }
    qrdata = jsonEncode(
        {'email': user.email, 'issues': booksList, 'returns': returnList});
    // printWrapped(qrdata);
  }
  @override
  createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  int checks = 0;

  recheck() async {
    await Future.delayed(Duration(seconds: 10));
    for (var book in widget.books) await issueBookModel(book, widget.user);
    setState(() {
      checks++;
      print("Rebuilding");
    });

    return 0;
  }

  redirect() async {
    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("issuecart");
    prefs.remove("returncart");

    gotoPage(context, null, clear: true, routeName: "/home");
  }

  @override
  Widget build(BuildContext context) {
    bool issued = checks > 0;
    if (!issued) recheck();

    List<Widget> children = [];
    if (issued) {
      children = [Text("Issued and Returned! Redirecting to home page...")];
      redirect();
    } else {
      children = [
        QrImage(data: widget.qrdata, version: QrVersions.auto, size: 200.0),
        Text("Show this QR code to the library admin"),
        Text("Not received confirmation from admin yet")
      ];
    }

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Check out")),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children),
                  SizedBox(height: 30.0),
                ])));
  }
}
