import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SimpleTextField extends StatelessWidget {
  String hint;
  SimpleTextField({this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: this.hint,
        ),
        validator: (String value) {
          return value == null ? "Value incorrect" : null;
        },
        initialValue: ""
    );
  }
}
