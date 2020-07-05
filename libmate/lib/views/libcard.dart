import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';

class LibcardPage extends StatefulWidget {
  @override
  _LibcardPageState createState() => _LibcardPageState();
}

class _LibcardPageState extends State<LibcardPage> {
  int booksRead = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: new AppBar(
        title: new Text('Bookerz Card'),
        centerTitle: true,

      ),
        drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0,40.0,30.0,0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/dekisugi.jpg'),
                radius: 60.0,

              ),
            ),
            Divider(
              height: 90.0,
              color: Colors.grey[800]
            ),
            Text(
              'NAME',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              )
            ),
            SizedBox(height:10.0),
            Text(
                'Dekisugi',
                style: TextStyle(
                  color: Colors.black87,
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold

                )
            ),
            SizedBox(height:30.0),
            Text(
                'BOOKS READ',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                )
            ),
            SizedBox(height:10.0),
            Text(
                '$booksRead',
                style: TextStyle(
                    color: Colors.pinkAccent,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold

                )
            ),
            SizedBox(height:30.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.book,
                  color: Colors.grey[400],

                ),
                Text(
                    'Genres',
                      style: TextStyle(
                      color: Colors.grey[600],
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold

                    )
                ),
              ]
            ),
            Column(
              children: <Widget>[
                Text(
                    'Science Fiction 100',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    )
                ),
                Text(
                    'Adventure 50',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    )
                ),

              ],
            )

          ]
        )
      )

    );
  }
}
