import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';

class LibcardPage extends StatefulWidget {
  @override
  _LibcardPageState createState() => _LibcardPageState();
}

class _LibcardPageState extends State<LibcardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Libcard Page'),
      ),
      drawer: AppDrawer(),
    );
  }
}
