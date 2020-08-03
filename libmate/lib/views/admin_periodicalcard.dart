// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/adminjournalcard.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/dummy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//user page  : two spearate pages for user(student) and admin
class PeriodicalPage extends StatefulWidget {
  @override
  _PeriodicalPageState createState() => _PeriodicalPageState();
}

class _PeriodicalPageState extends State<PeriodicalPage> {
  var isLoaded = false;
  var cards = [];

  Future loadData() async {
    var snapshot =
        await Firestore.instance.collection("journals").getDocuments();
    var card = [];
    for (var doc in snapshot.documents) {
      var data = doc.data;
      card.add(JournalModel(
          name: data['name'],
          title: doc['title'],
          description: data['description'],
          image: data['image'],
          impactfactor: data['impactfactor'].toString(),
          chiefeditor: data['chiefeditor'],
          volume: data['volume'].toString(),
          issue: data['issue'],
          issn: data['issn'],
          date: data['date']));
    }
    setState(() {
      cards = card;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<Widget> cardgen() {
    return cards.map((e) => AdminjournalCard(model: e)).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Periodicals"),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Periodicals',
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
              child: Container(
            constraints: BoxConstraints(minHeight: 150, maxHeight: 250),
            child: isLoaded == false
                ? Text('loading..')
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: cardgen(),
                  ),
          )),
        ]));
  }
}
