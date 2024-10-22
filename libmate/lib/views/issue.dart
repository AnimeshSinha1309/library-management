import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/views/drawer.dart';
import 'package:provider/provider.dart';

class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  TextEditingController _isbnController = TextEditingController(),
      _accNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (BuildContext context, UserModel model, Widget child) {
          var submitIssue = RaisedButton(
            onPressed: () {
              issueBook(
                  _isbnController.text, model, _accNoController.text);
            },
            child: Text('Submit'),
          );
          var submitReturn = RaisedButton(
            onPressed: () {
              returnBook(
                  _isbnController.text, model, _accNoController.text);
            },
            child: Text('Return'),
          );

          return Scaffold(
            appBar: new AppBar(
              title: new Text('Issue Book'),
            ),
            drawer: AppDrawer(),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _isbnController,
                      decoration: InputDecoration(
                        labelText: "Book ISBN",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _accNoController,
                      decoration: InputDecoration(
                        labelText: "Accession Number",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Builder(builder: (context) => submitIssue),
                    Builder(builder: (context) => submitReturn),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
