import 'package:flutter/material.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:libmate/widgets/issueitem.dart';

class Home extends StatelessWidget {
  final Icon customIcon = Icon(Icons.search);
  final Widget customHeading = Text("LibMate");

  List<Widget> generateRecommendations() {
    return cachedBooks.map((e) => BookCard(model: e)).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: customHeading,
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
                'Hi there, Animesh!',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Open Sans',
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
            )),
            SliverToBoxAdapter(
                child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                'Here are some hot picks of the day for you to read.',
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: generateRecommendations(),
              ),
            )),
            SliverToBoxAdapter(
                child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                'Books you have issued.',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Open Sans',
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      IssuedBookCard(model: borrowedBooks[index]),
                  childCount: borrowedBooks.length),
            ),
          ],
        ));
  }
}
