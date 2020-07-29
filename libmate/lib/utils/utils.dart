import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io' show File;

void gotoPage(BuildContext context, dynamic page) {
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
  Navigator.of(context).push(route);
}

void showToast(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

const config = {"razorkey": "rzp_test_U4H7R8ZUFz2iHt"};
