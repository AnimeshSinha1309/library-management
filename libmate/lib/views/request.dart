import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/widgets/request.dart';
import 'package:validators/validators.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();
  RequestBookModel model = RequestBookModel();
  // RegExp exp = new RegExp(r"^(?=(?:\D*\d){10}(?:(?:\D*\d){3})?$)[\d-]+$");  # regex for isbn

  bool doesExist(String isbn) {
    return false;
  }

  void sendRequest(RequestBookModel model) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Request Page'),
      ),
      drawer: AppDrawer(),
      body: Builder(
          builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Name of the Book"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the name of the Book.';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.name = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "ISBN of the Book"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the ISBN of the book';
                            }
                            else if(!isISBN(value)) {
                              return 'Please enter the valid ISBN';
                            }
                            else if(doesExist(value)) {
                              return 'This book is in the library';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.isbn = value;
                          },
                        ),
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   decoration:
                        //       InputDecoration(hintText: "Estimated Price"),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'Please enter an approximate price for it.';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Genre / Subject"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter the Subject / Genre.';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.subject = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Reasons, Cosigners, etc."),
                          maxLines: 3,
                          onSaved: (String value) {
                            model.reason = value.isEmpty ? model.reason : value;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            color: Colors.pinkAccent,
                            onPressed: () {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a Snackbar.
                                sendRequest(model);
                                _formKey.currentState.reset();
                                showToast(context,
                                    'Backend for the App is not Ready');
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ),
              )),
    );
  }
}
