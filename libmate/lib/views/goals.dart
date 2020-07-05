import 'package:flutter/material.dart';
import './drawer.dart';
import './toRead.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List <ToRead> books = [
    ToRead(book:"Three men in a Boat",date:"28/7"),
    ToRead(book:"Three men in a Boat",date:"28/7"),
    ToRead(book:"Three men in a Boat",date:"28/7"),
  ];
  Widget ToReadTemplate(book)
  {
    return Card(
        margin: EdgeInsets.fromLTRB(2,2,2,0),
        child: Column(
            children: <Widget>[
              Text(
                  book.book,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  )
              ),
              SizedBox(height:4),
              Text(
                  book.date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[1000],
                  )
              )
            ]
        )

    );
  }
  int numBooks = 3;
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
              books.add(ToRead(book:"New Book",date:"28/7"));
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
                            'To Read :',
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
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: books.map((b){
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
//                              Text("${b.book} : ${b.date}"),
                              ToReadTemplate(b),
                              Center(
                                child: RaisedButton.icon(
                                  onPressed: (){},
                                  color: Colors.amber,
                                  icon: Icon(Icons.add_shopping_cart),
                                  label: Text('issue'),
                                ),
                              ),

                            ]);
                      }).toList()),
                  SizedBox(height:30.0),

                ]
            )
        )

    );
  }
}