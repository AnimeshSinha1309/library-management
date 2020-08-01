import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/journalcard.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/dummy.dart';

//user page  : two spearate pages for user(student) and admin
class JournalPage extends StatefulWidget {

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  List<Widget> cardgen() {
    return dummyJournals.map((e) => JournalCard(model: e)).toList(growable: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journals"),
        centerTitle: true,
      ),
      drawer: AppDrawer(),

        body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
              child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                'The available journals',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Open Sans',
                  fontSize: 18,
                   ),
                textAlign: TextAlign.left,
                 ),
              )),
              SliverToBoxAdapter(
              child:
                Container(
                  constraints: BoxConstraints(minHeight: 150, maxHeight: 250),
                  child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: cardgen(),
                  ),
                )),
              ]));
  }
}