import 'package:flutter/material.dart';
import 'package:libmate/services/auth.dart';
import 'package:libmate/views/drawer.dart';
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

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor : Colors.white,
      appBar: AppBar(
          title: Text("Sign in"),
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
            child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (val){
                        setState(() => email = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
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
                    ),
                    onPressed: () async{
                      print(email);
                      print(password);

                    },

                  )


                ],

            ),



          ),

        ),
      ),
    );
  }
}