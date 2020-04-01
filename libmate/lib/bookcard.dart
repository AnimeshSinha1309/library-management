import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  final String title;
  final String author;
  final String isbn;
  final String image;
  final String subject;
  final String series;
  final String genre;

  const BookCard(
      {Key key,
      this.title,
      this.author,
      this.isbn,
      this.image,
      this.subject,
      this.series,
      this.genre})
      : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.image),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: FractionallySizedBox(
              heightFactor: 0.6,
              widthFactor: 1.0,
              child: InkWell(
                splashColor: Colors.white,
                onTap: () {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Receiving Tap Event on Card!")));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Color.fromRGBO(0, 0, 0, 0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.series,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Text(
                        widget.author,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Genre: " + widget.genre,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "ISBN: " + widget.isbn,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
