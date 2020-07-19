import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
//user page  : two spearate pages for user(student) and admin
class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int booksRead = 100;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          title: new Text('Guide'),
          centerTitle: true,

        ),
        drawer: AppDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0,40.0,30.0,0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'LibMate How tos',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:10.0),
                  Text(
                      'Your digital library management system, Andaman college',
                      style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 2.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold

                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'Personalized book recommendations',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'Voice assistant and chatbot',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'Issue/return books easily',
                        style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'Get unlimited ebooks',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'Create to dos',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'Ratings based on number of books read',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),



                ]
            )
        )

    );
  }
}
