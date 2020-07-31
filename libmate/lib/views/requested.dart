import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/requested.dart';
import 'package:libmate/widgets/requestedbookcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class RequestedPage extends StatefulWidget {
  @override
  _RequestedPageState createState() => _RequestedPageState();
}

class _RequestedPageState extends State<RequestedPage> {
  Timer timer;
  bool _loaded = false;
  Set<RequestedBookModel> books = Set<RequestedBookModel>();

  void requestedBooks() async {
    try {
      final snapShot = await Firestore.instance
          .collection('requested books')
          .orderBy("cnt", descending: true)
          .getDocuments();
      Set<RequestedBookModel> requestlist = Set<RequestedBookModel>();

      for (var document in snapShot.documents) {
        var book = RequestedBookModel();
        book.isbn = document.documentID;
        book.name = document.data['name'];
        book.subject = document.data['subject'];
        book.cnt = document.data['cnt'];
        book.reason = document.data['reason'];
        book.image = document.data['image'];
        requestlist.add(book);
      }
      setState(() {
        books = requestlist;
        _loaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    requestedBooks();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      requestedBooks();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void removeBook(RequestedBookModel book) async {
    Navigator.of(context).pop();
    setState(() {
      books.remove(book);
    });
    try {
      await Firestore.instance
          .collection('requested books')
          .document(book.isbn)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Book Requests'),
      ),
      drawer: AppDrawer(),
      body: _loaded == true ? _buildBooks() : Text('loading...'),
    );
  }

  Widget _buildBooks() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: books.map((RequestedBookModel book) {
        return RequestedBookCard(
            model: book, removeBook: removeBook, shouldOpenPage: true);
      }).toList(),
    );
  }
}
