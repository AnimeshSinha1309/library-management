import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/datastore/model.dart';
import 'dart:convert';

class Checkout extends StatefulWidget {
  String qrdata;
  String uid;
  List<BookModel> books;
  UserModel user;

  // uid for checking issue status of books
  Checkout(this.books, this.user) {
    uid = user.email;
    List<dynamic> datalist = [];
    datalist.add(user.email);
    for (var book in books) {
      datalist.add(book.toJSON());
    }
    qrdata = jsonEncode(datalist);
  }
  @override
  createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  int checks = 0;

  recheck() async {
    await Future.delayed(Duration(seconds: 2));
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

    gotoPage(context, null, clear: true, routeName: "/home");
  }

  @override
  Widget build(BuildContext context) {
    bool issued = checks > 0;
    if (!issued) recheck();

    List<Widget> children = [];
    if (issued) {
      children = [Text("Issued! Redirecting to home page...")];
      redirect();
    } else {
      children = [
        QrImage(data: widget.qrdata, version: QrVersions.auto, size: 200.0),
        Text("Not received confirmation from admin yet")
      ];
    }

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Issue book")),
        body: Column(children: children));
  }
}
