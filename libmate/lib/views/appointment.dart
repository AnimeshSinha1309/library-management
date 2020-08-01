import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/timeslots.dart';

class AppointmentPage extends StatefulWidget {
  final UserModel user;

  AppointmentPage({this.user});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Appointment Scheduler'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Select what you want to do inside library and get appointment",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: ButtonTheme(
                            textTheme: ButtonTextTheme.primary,
                            child: RaisedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TimePage()),
                                );
                              },
                              icon: Icon(Icons.assignment_return),
                              label: Text('Issue / Return\n       book'),
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        ButtonTheme(
                          textTheme: ButtonTextTheme.primary,
                          child: RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimePage(user: widget.user)),
                              );
                            },
                            icon: Icon(Icons.person_pin),
                            label: Text('Sit in Library'),
                          ),
                        )
                      ]),
                ])));
  }
}
