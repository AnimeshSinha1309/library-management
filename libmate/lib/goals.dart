import 'package:flutter/material.dart';

import './drawer.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List <String> books = ["Three men in a Boat"];
  int numBooks = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Goals'),
      ),

        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState((){
              books.add("Dummy book");
              numBooks += 1;
            });


          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0,40.0,30.0,0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height:30.0),
                  Row(
                      children: <Widget>[
                        Icon(
                          Icons.bookmark,
                          color: Colors.grey[400],

                        ),
                        Text(
                            'SAVED BOOKS :',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                            )
                        ),
                        SizedBox(height:10.0),
                        Text(
                            '$numBooks',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,

                            )
                        ),
                      ]
                  ),

                  SizedBox(height:30.0),
                  Text(
                      'Three men in a boat',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          letterSpacing: 2.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold

                      )
                  ),
                  SizedBox(height:30.0),

                ]
            )
        )

    );
  }
}
