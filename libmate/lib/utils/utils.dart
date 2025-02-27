import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io' show File;
import 'dart:async';

void gotoPage(BuildContext context, dynamic page,
    {bool clear = false, String routeName = ""}) {
  var route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      });
  if (clear)
    Navigator.pushNamedAndRemoveUntil(context, routeName, (r) => false);
  else
    Navigator.of(context).push(route);
}

void showToast(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

dynamic readBookData(response) {
  var usable_body = response.body.replaceAllMapped(RegExp(r"NaN,"), (match) {
    return "\"\",";
  });
  usable_body =
      usable_body.replaceAllMapped(RegExp(r'(, )?"\w+": NaN'), (match) {
    return "";
  });

  return json.decode(usable_body);
}

const config = {"razorkey": "rzp_test_U4H7R8ZUFz2iHt"};
