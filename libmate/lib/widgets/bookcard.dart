import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double height = 200;

    return Card(
        elevation: 5,
        child: Row(children: [
          Expanded(
            flex: 3,
            child: Container(
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.fitHeight,
                  ),
                )),
          ),
          Expanded(
              flex: 4,
              child: Material(
                color: Color.fromRGBO(0, 0, 0, 0.9),
                child: InkWell(
                  splashFactory: InkRipple.splashFactory,
                  splashColor: Colors.white,
                  onTap: () {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Receiving Tap Event on Card!")));
                  },
                  child: Container(
                    height: height,
                    padding: EdgeInsets.all(8),
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          series,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          author,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Genre: " + genre,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "ISBN: " + isbn,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ]));
  }
}
