import 'package:flutter/material.dart';
import 'package:libmate/services/auth.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/shared/constants.dart';
class SignIn extends StatefulWidget{
  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();

}
class _SignInState extends State<SignIn>
{
  final AuthService _auth = AuthService();
  String email = "";
  String password = "";
  String error = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor : Colors.white,
      appBar: AppBar(
          title: Text("Sign in to Libmate"),
          centerTitle: true,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () async {
                widget.toggleView();
              },
            )
          ]
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: RaisedButton(
          child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? "Enter an email" : null,
                    onChanged: (val){
                        setState(() => email = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'password'),
                    validator: (val) => val.length < 6 ? "Enter a password 6+ chars long" : null,
                    obscureText: true,
                    onChanged: (val){
                        setState(() => password = val);
                      }
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                         "Sign in",
                          style: TextStyle(color: Colors.white),
                    ),                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() => error = 'Please supply a valid email');
                      }
                    }
                  }),
                  SizedBox(height: 20.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
            ),
          ),
        ),
      ),
    );
  }
}
