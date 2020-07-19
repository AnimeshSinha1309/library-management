import 'package:flutter/cupertino.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/bookcard.dart';

class Book extends StatelessWidget {
  BookModel model;

  Book({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(children: [
        BookCard(model: model),
        Row(children: [
          Text("Total copies: 5"),
          Text("Copies available: 5"),
        ])
      ]),
    );
  }
}
