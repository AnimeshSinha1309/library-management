import 'package:flutter/material.dart';

import './drawer.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Request Page'),
        ),
        drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Name of the Book"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the name of the Book.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Estimated Price"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an approximate price for it.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Genre / Subject"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter the Subject / Genre.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration:
                    InputDecoration(hintText: "Reasons, Cosigners, etc."),
                    maxLines: 3,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(children: <Widget>[
                        RaisedButton(
                          color: Colors.pinkAccent,
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Backend for the App is not Ready')));
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        Center(
                          child: RaisedButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a Snackbar.
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Backend for the App is not Ready')));
                              }
                            },
                            child: Text(
                              'Broadcast Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ])),
                ]),
          ),
        ));
  }
}