import 'package:flutter/material.dart';

import './drawer.dart';

class LibcardPage extends StatefulWidget {
  @override
  _LibcardPageState createState() => _LibcardPageState();
}

class _LibcardPageState extends State<LibcardPage> {
  int roll = 2019121004;
  @override
  Widget build(BuildContext context) {
    List<String> books = [
      "Linear Algebra: Strang",
      "To Kill a Mockingbird",
      "Algorithms: Cormen"
    ];

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          title: new Text('Library Card'),
          centerTitle: true,

        ),
        drawer: AppDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0,20.0,20.0,0.0),
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
                      'Dekisugi Daga',
                      style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 2.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold

                      )
                  ),

                  SizedBox(height:30.0),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'ROLL NUMBER',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:10.0),
                  Text(
                      '$roll',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          letterSpacing: 2.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold

                      )
                  ),
                  ]),
                  SizedBox(height:30.0),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                   Text(
                        'Batch',
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0,
                        )
                    ),
                    SizedBox(height:10.0),
                    Text(
                        '2018',
                        style: TextStyle(
                            color: Colors.black87,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold

                        )
                    ),
                    ]
                  ),
                  SizedBox(height:30.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'Programme',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                            )
                        ),
                        SizedBox(height:10.0),
                        Text(
                            'B.Tech',
                            style: TextStyle(
                                color: Colors.black87,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold

                            )
                        ),
                      ]
                  ),
                  SizedBox(height:30.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'Stream',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                            )
                        ),
                        SizedBox(height:10.0),
                        Text(
                            'Computer Science',
                            style: TextStyle(
                                color: Colors.black87,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold

                            )
                        ),
                      ]
                  ),
                ]
            )
        )
    );
  }
}