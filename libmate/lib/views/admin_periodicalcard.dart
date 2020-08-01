import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/adminjournalcard.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/dummy.dart';

//user page  : two spearate pages for user(student) and admin
class PeriodicalPage extends StatefulWidget {

  @override
  _PeriodicalPageState createState() => _PeriodicalPageState();
}

class _PeriodicalPageState extends State<PeriodicalPage> {
  @override
  List<Widget> cardgen() {
    return dummyJournals.map((e) => AdminjournalCard(model: e)).toList(growable: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Periodicals"),
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
                  child:
                  Container(
                    constraints: BoxConstraints(minHeight: 150, maxHeight: 250),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: cardgen(),
                    ),
                  )
              ),
            ]));
  }
}