import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/timeslots.dart';
import 'package:libmate/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppointmentPage extends StatefulWidget {
  final UserModel user;


  AppointmentPage({this.user});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int timeinterval = -1;
  int type = -1;


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
                                  timeinterval = 10;
                                  type=0;
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
                              timeinterval = 30;
                              type = 1;
                            },
                            icon: Icon(Icons.person_pin),
                            label: Text('Sit in Library'),
                          ),
                        )
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
                                if(type==-1)
                                {
                                  Fluttertoast.showToast(
                                      msg: " please select options among issue/return or sit in lib then select day",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );

                                }
                                else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TimePage(user: widget.user, type: type, timeInterval: timeinterval, day: 'today')),
                                  );
                                }

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
                                  if(type==-1)
                                    Fluttertoast.showToast(
                                        msg: " please select options among issue/return or sit in lib then select day",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  else{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimePage(user: widget.user, type: type, timeInterval: timeinterval, day: 'tommorow')),
                                    );
                                  }

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
