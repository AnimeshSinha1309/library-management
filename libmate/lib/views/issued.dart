import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/issuedbookcard.dart';
// import 'package:libmate/datastore/model.dart';


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
        title: new Text('About issued books'),
      ),
      drawer: AppDrawer(),
      body: _buildBooks(),
    );
  }


  Widget _buildBooks() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: _issuedBooks.map((BorrowBookModel book) {
        return IssuedBookCard(model: book);
        // return Text('Name:' + book.name);
      }).toList(),
    );
  }

}




const String def = "not found";
const String defImage =
    "http://assets.stickpng.com/images/5847f289cef1014c0b5e486b.png";

class BorrowBookModel {

  final String name;
  String author = def;
  String isbn = def;
  String image = defImage;
  String subject = def;
  String genre = def;
  String accessionNumber = def;
  final DateTime borrowDate = DateTime.parse('2020-07-10');
  final DateTime dueDate = DateTime.parse('2020-07-20');
  final double fine = 2.0;

  BorrowBookModel({@required this.name, this.author, this.isbn, this.subject, this.genre, this.accessionNumber});
}