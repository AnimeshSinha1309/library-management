import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:libmate/widgets/issueitem.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final Icon customIcon = Icon(Icons.search);
  final Widget customHeading = Text("LibMate");

  List<Widget> generateRecommendations() {
    List<BookCard> recommendations = [];
    cachedBooks.forEach((String key, BookModel value) {
      if (recommendations.length < 6)
        recommendations.add(BookCard(model: value));
    });
    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (BuildContext context, UserModel model, Widget child) {
      print(model.borrowedBooks);
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
                  'Hi there, ${model.name}!',
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
                        IssuedBookCard(model: model.borrowedBooks[index]),
                    childCount: model.borrowedBooks.length),
              ),
            ],
          ));
    });
  }
}
