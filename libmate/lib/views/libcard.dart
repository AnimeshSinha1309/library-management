import 'package:flutter/material.dart';
import 'package:libmate/datastore/dummy.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/issueitem.dart';

class LibcardPage extends StatefulWidget {
  @override
  _LibcardPageState createState() => _LibcardPageState();
}

class _LibcardPageState extends State<LibcardPage> {
  int booksRead = 100;
  List<BorrowBookModel> _issuedBooks;

  @override
  void initState() {
    this._issuedBooks = <BorrowBookModel>[
      BorrowBookModel(
        book: dummyBooks[1],
        accessionNumber: 2,
        borrowDate: DateTime.now().subtract(Duration(days: 11)),
      ),
      BorrowBookModel(
        book: dummyBooks[0],
        accessionNumber: 1,
        borrowDate: DateTime.now().subtract(Duration(days: 18)),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statsGroup = SliverToBoxAdapter(
      child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 30.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: [
                  Text('Reader',
                      style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 2.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  Column(children: [
                    Text('BOOKS READ',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0,
                        )),
                    Text('$booksRead',
                        style: TextStyle(
                            color: Colors.pinkAccent,
                            letterSpacing: 2.0,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold)),
                  ])
                ]),
                Row(children: <Widget>[
                  Icon(
                    Icons.book,
                    color: Colors.grey[400],
                  ),
                  Text('Genres',
                      style: TextStyle(
                          color: Colors.grey[600],
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold)),
                ]),

                Column(
                  children: <Widget>[
                    Text('Science Fiction 100',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0,
                        )),
                    Text('Adventure 50',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0,
                        )),
                  ],
                ),
              ]
          )
      ),
    );

    var dueBooks = SliverList(
      delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) =>
              IssuedBookCard(model: _issuedBooks[index]),
          childCount: _issuedBooks.length),
    );

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          title: new Text('Library Card'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: CustomScrollView(
          slivers: [statsGroup, dueBooks],
        ));
  }
}
