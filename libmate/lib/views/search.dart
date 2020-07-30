import 'dart:convert';
import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/bookcard.dart';

class SearchPage extends StatefulWidget {
  final fuse;

  SearchPage({this.fuse});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Search'),
        ),
        drawer: new AppDrawer(),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: SafeArea(
              left: true,
              right: true,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: buildField("Name of the Book", "title")),
                  SliverToBoxAdapter(child: buildQueryOptions()),
                  buildResultsPane(),
                ],
              ),
            )));
  }

  /// Results Display Segment:
  ///  Maintains and displays the results generated by the query
  ///  as book cards

  List<BookModel> data;
  bool searchLoading = false;

  void scheduleSearch() async {
    Map<String, String> query = Map<String, String>();
    searchControllers.forEach((key, value) {
      if (value.text.length > 0) query[key] = value.text;
    });

    // Reject if empty, otherwise start loading
    if (query.isEmpty) return;
    setState(() {
      searchLoading = true;
    });

    // Query the URL
    Uri url = Uri.https("libmate.herokuapp.com", "/query", query);
    final result = await http.get(url); // call api;
    if (result.statusCode != 200) {
      print('ERROR: Search did not return a 200 Server response code');
      return;
    }
    // Process the response
    var response = readBookData(result);
    List<BookModel> searchResults = List();
    for (var res in response) {
      searchResults.add(BookModel.fromJSON(res));
    }
    // Set the state again
    setState(() {
      data = searchResults;
      searchLoading = false;
    });
  }

  Widget buildResultsPane() {
    if (searchLoading) {
      return SliverToBoxAdapter(
          child: Center(
              child: SizedBox(
        child: CircularProgressIndicator(),
        height: 50.0,
        width: 50.0,
      )));
    } else if (data == null || data.length == 0) {
      return SliverToBoxAdapter(child: Text("No items in data view"));
    } else {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => BookCard(model: data[index]),
          childCount: data == null ? 0 : data.length,
        ),
      );
    }
  }

  /// Search Option Segment:
  ///  Deals with setting up the expanded windows, maintaining controllers
  ///  and putting together the query string

  Map<String, TextEditingController> searchControllers = Map();
  final _formKey = GlobalKey<FormState>();
  final _debouncer = Debouncer(milliseconds: 500);

  buildField(String label, String id) {
    if (!searchControllers.containsKey(id)) {
      var controller = TextEditingController();
      controller.addListener(() {
        _debouncer.run(scheduleSearch);
      });
      searchControllers[id] = controller;
    }
    return TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: searchControllers[id]);
  }

  Widget buildQueryOptions() {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Colors.indigoAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Advanced options",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expanded: Form(
                    key: _formKey,
                    child: Column(children: [
                      buildField("Author", "author"),
                      buildField("Category", "tag"),
                      buildField("Publisher", "publisher"),
                    ])),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    searchControllers.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
