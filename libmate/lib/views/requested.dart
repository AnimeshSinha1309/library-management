import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/request.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/widgets/requestedbookcard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RequestedPage extends StatefulWidget {
  @override
  _RequestedPageState createState() => _RequestedPageState();
}

class _RequestedPageState extends State<RequestedPage> {
  Timer timer;
  Set<RequestedBookModel> books = Set<RequestedBookModel>();

  void requestedBooks() async {
    final response = await http.get(
        'https://libmate.herokuapp.com/view-requested-books?sort=cnt&flag=1');
    Set<RequestedBookModel> requestlist = Set<RequestedBookModel>();
    if (response.statusCode == 200) {
      var jsonData = readBookData(response);
      for (var book in jsonData) {
        requestlist.add(RequestedBookModel.fromJson(book));
      }
    }
    setState(() {
      books = requestlist;
    });
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

  void removeBook(RequestBookModel book) async {
    setState(() {
      books.remove(book);
    });
    final res = await http.post(
      'https://libmate.herokuapp.com/delete-requested-book',
      body: book.toMap(),
    );
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
