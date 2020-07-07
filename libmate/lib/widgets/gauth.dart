import 'package:flutter/material.dart';

class GAuthButton extends StatelessWidget {
  const GAuthButton({
    this.callback,
    this.text = 'Sign In'
  });

  final VoidCallback callback;
  final String text;
  
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
                  this.text,
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
