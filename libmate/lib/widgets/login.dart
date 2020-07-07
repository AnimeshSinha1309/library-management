import 'package:flutter/material.dart';

/* The Visual Elements used for the Auth pages */

class SignOutButton extends StatelessWidget {
  const SignOutButton({this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        this.callback();
      },
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Sign Out',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        splashColor: Colors.grey,
        color: Colors.white,
        onPressed: () {
          this.callback();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/logo-google.png"), height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
