import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/timeslots.dart';


class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage > {
 var date =  new DateTime.now();
 var option = -1;
// option = 0: Issue/Return book
// and 1: sit in lib

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Appointment Scheduler'),
          centerTitle: true,

        ),
        drawer: AppDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0,40.0,30.0,0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Select what you want to do inside library and get appointment",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    Center(
                      child: ButtonTheme(
                        textTheme: ButtonTextTheme.primary,
                        child: RaisedButton.icon(
                          onPressed: () {
                            option = 0;
                          },
                          icon: Icon(Icons.assignment_return),
                          label: Text('Issue/Return book'),
                        ),
                      ),
                    ),
                     Center(
                        child: ButtonTheme(
                          textTheme: ButtonTextTheme.primary,
                          child: RaisedButton.icon(
                            onPressed: () {
                                option = 1;
                            },
                            icon: Icon(Icons.person_pin),
                            label: Text('Sit in Library'),
                          ),
                        )),
                  ]),
                  Text(
                      "Select day",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: ButtonTheme(
                            textTheme: ButtonTextTheme.primary,
                            child: RaisedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TimePage(date,option,"today")),
                                );
                              },
                              icon: Icon(Icons.today),
                              label: Text('Today'),
                            ),
                          ),
                        ),
                        Center(
                            child: ButtonTheme(
                              textTheme: ButtonTextTheme.primary,
                              child: RaisedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TimePage(date,option,"tommorow")),
                                  );
                                },
                                icon: Icon(Icons.arrow_forward),
                                label: Text('Tommorow'),
                              ),
                            )),
                      ]),

                ]
            )
        )

    );
  }
}
