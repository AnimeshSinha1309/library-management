import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/widgets/request.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();
  RequestBookModel model = RequestBookModel();

  Future<bool> doesExist(String isbn) async {
    final response =
        await http.get('https://libmate.herokuapp.com/query?isbn=$isbn');
    bool res = response.body.length != 0;
    return res;
  }

  Future<String> sendRequest(RequestBookModel model) async {
    // final res = await doesExist(model.isbn);
    // if (res) {
    //   return "This book is present in the library";
    // }
    final response = await http.post(
        'https://libmate.herokuapp.com/request-book',
        body: model.toMap());

    if (response.statusCode == 200) {
      _formKey.currentState.reset();
      return "Request Submitted!!";
    } else {
      return "Error sending request!";
    }
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
                            } else if (!isISBN(value)) {
                              return 'Please enter the valid ISBN';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.isbn = value;
                          },
                        ),
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
                            model.reason = value.isEmpty ? def : value;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            color: Colors.pinkAccent,
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                showToast(context, "Sending Request..");
                                final String resp = await sendRequest(model);
                                showToast(context, resp);
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
