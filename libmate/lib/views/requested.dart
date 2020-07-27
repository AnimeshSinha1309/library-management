import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/request.dart';
import 'package:libmate/widgets/requestedbookcard.dart';
import 'dart:async';

class RequestedPage extends StatefulWidget {
  @override
  _RequestedPageState createState() => _RequestedPageState();
}

class _RequestedPageState extends State<RequestedPage> {
  Timer timer;
  Set<RequestedBookModel> books = Set<RequestedBookModel>();

  Set<RequestedBookModel> requestedBooks() {
    Set<RequestedBookModel> requestlist = Set<RequestedBookModel>();
    requestlist.add(RequestedBookModel(
        uid: "01",
        name: "Gulliver's Travels",
        isbn: "9781982654368",
        subject: "Fiction"));
    requestlist.add(RequestedBookModel(
        uid: "10",
        name: "Gulliver's Travels",
        isbn: "9781982654368",
        subject: "Fiction"));
    return requestlist;
  }

  @override
  void initState() {
    super.initState();
    books = requestedBooks();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        books = requestedBooks();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void removeBook(RequestBookModel book) {
    setState(() {
      books.remove(book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Book Requests'),
      ),
      drawer: AppDrawer(),
      body: _buildBooks(),
    );
  }

  Widget _buildBooks() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: books.map((RequestedBookModel book) {
        return RequestedBookCard(
            model: book, removeBook: removeBook, shouldOpenPage: false);
      }).toList(),
    );
  }
}
