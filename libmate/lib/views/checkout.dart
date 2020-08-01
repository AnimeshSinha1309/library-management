import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';

class Checkout extends StatefulWidget {
  String data;
  String uid;

  // uid for checking issue status of books
  Checkout(data, uid) {
    this.uid = uid;
    this.data = data + uid;
  }
  @override
  createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  int checks = 0;

  recheck() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      checks++;
      print("Rebuilding");
    });

    return 0;
  }

  redirect() async {
    await Future.delayed(Duration(seconds: 2));
    gotoPage(context, null, clear: true, routeName: "/home");
  }

  @override
  Widget build(BuildContext context) {
    bool issued = checks > 0;
    if (!issued) recheck();

    List<Widget> children = [];
    if (issued) {
      children = [Text("Issued! Redirecting to home page...")];
      redirect();
    } else {
      children = [
        QrImage(data: widget.data, version: QrVersions.auto, size: 200.0),
        Text("Not received confirmation from admin yet")
      ];
    }

    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("Issue book")),
        body: Column(children: children));
  }
}
