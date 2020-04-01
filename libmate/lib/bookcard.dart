import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final String title;
  final String author;
  final String isbn;
  final String image;

  const BookCard({
    Key key,
    this.title,
    this.author,
    this.isbn,
    this.image,
  }) : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Stack(
        children: [
          Image.network(
            widget.image,
            fit: BoxFit.fill,
          ),
          Icon(Icons.star),
          FractionallySizedBox(
            widthFactor: 1.0,
            heightFactor: 0.5,
            alignment: FractionalOffset.bottomLeft,
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.9),
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.author,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ]
              )
            ),
          ),
        ]
      ),
    );
  }
}
