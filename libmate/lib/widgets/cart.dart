import 'package:libmate/datastore/model.dart';
import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/checkout.dart';
import 'dart:convert';

class BookCartUI extends StatefulWidget {
  @override
  createState() => BookCartState();
}

class BookCartState extends State<BookCartUI> {
  BookCart cart;

  BookCartState({@required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Your cart")),
        body: Column(children: [
          RaisedButton(
              child: Text("Checkout"),
              onPressed: () {
                String data = jsonEncode(toJSON());
                gotoPage(context, Checkout(data));
              })
        ]));
  }

  dynamic toJSON() {
    return cart.toJSON();
  }
}
