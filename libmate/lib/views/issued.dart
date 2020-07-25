import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/issuedbookcard.dart';


class IssuedPage extends StatefulWidget {
  @override
  _IssuedPageState createState() => _IssuedPageState();
}

class _IssuedPageState extends State<IssuedPage> {
  final _issuedBooks = <BorrowBookModel>[];

  @override
  void initState() {
    super.initState();
    final BorrowBookModel b1 = new BorrowBookModel(
        name: 'Introduction to Linear Algebra',
        author: 'Gilbert Strang',
        isbn: '9780980232776',
        subject: 'Linear Algebra',
        genre: 'Math');
    final BorrowBookModel b2 = new BorrowBookModel(
        name: 'Linear Algebra',
        author: 'Gilbert Strang',
        isbn: '9780980232776',
        subject: 'Linear Algebra',
        genre: 'Math');
    _issuedBooks.add(b1);
    _issuedBooks.add(b2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Your issued books'),
      ),
      drawer: AppDrawer(),
      body: _buildBooks(),
    );
  }

  Widget _buildBooks() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: _issuedBooks.map((BorrowBookModel book) {
        return IssuedBookCard(model: book, shouldOpenPage: true);
      }).toList(),
    );
  }
}
