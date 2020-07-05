import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';



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
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
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
                      'John Doe',
                      style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 2.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold

                      )
                  ),
                  SizedBox(height:30.0),
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
                  SizedBox(height:30.0),
                  Row(
                      children: <Widget>[
                        Icon(
                          Icons.book,
                          color: Colors.grey[400],

                        ),
                        Text(
                            'Books Issued',
                            style: TextStyle(
                                color: Colors.grey[600],
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold

                            )
                        ),
                      ]
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: books.map((book){
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("$book"),
                              Center(
                                child: RaisedButton.icon(
                                  onPressed: (){},
                                  color: Colors.amber,
                                  icon: Icon(Icons.launch),
                                  label: Text('Return'),
                                ),
                              ),
                              Center(
                                child: RaisedButton.icon(
                                  onPressed: (){},
                                  color: Colors.amber,
                                  icon: Icon(Icons.swap_horiz),
                                  label: Text('Re-issue'),
                                ),
                              ),

                            ]);
                      }).toList()),

                ]
            )
        )

    );
  }
}
