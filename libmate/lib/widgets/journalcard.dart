import 'dart:convert';
import 'package:libmate/datastore/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/journals.dart';
import 'package:libmate/widgets/toread.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalCard extends StatelessWidget {
  final JournalModel model;
  final bool shouldOpenPage;

  JournalCard({@required this.model, this.shouldOpenPage = true})
      : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: SizedBox(
          height: 250,
          width: 150,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.image),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FractionallySizedBox(
                  heightFactor: 0.6,
                  widthFactor: 1.0,
                  child: Material(
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      splashColor: Colors.white,
                      onTap: () {
                        if (shouldOpenPage)
                          gotoPage(context, JournalPage(model: model));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Color.fromRGBO(0, 0, 0, 0.9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                model.name ?? "",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                (model.title ?? model.title),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            Flexible(
                              child: Text(
                                "volume: " + (model.volume ?? "")+ " issue: " + (model.issue ?? ""),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            Flexible(
                              child: Text(
                                      "date: " + (model.date ?? ""),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),

                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ));
  }
}
class JournalPage extends StatelessWidget {
  final JournalModel model;
  final int maxBooks = 20;

  JournalPage({@required this.model});

  Future<int> saveReadingList(JournalModel model) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> readList = prefs.getStringList("readingList") ?? [];
    if (readList.length > maxBooks) return 1;

    ToRead rBook = new ToRead();
    rBook.book = model.name ?? "";
    rBook.date = new DateFormat("dd/MM").format(DateTime.now()).toString();

    String sBook = json.encode(rBook);
    bool found = false;
    for (var it = 0, name = sBook.split(',')[0]; it < readList.length; it++) {
      if (readList[it].split(',')[0] == name) {
        readList[it] = sBook;
        found = true;
        break;
      }
    }

    if (!found) readList.add(sBook);

    return (await prefs.setStringList("readingList", readList)) ? 0 : 2;
  }


  Future<String> addJournal(JournalModel model) async {
    int res = await saveReadingList(model);
    if (res == 0) {
      return "Added to reading list";
    } else if (res == 1) {
      return "Exceeded max size of reading list";
    } else if (res == 2) {
      return "Error saving reading list!";
    } else {
      return "Unknown Error";
    }
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: new AppBar(
//          title: new Text(model.title),
//        ),
//        drawer: AppDrawer(),
//        body: Builder(
//            builder: (context) => Column(children: [
//              JournalCard(model: model),
//              Text("Impact Factor: "+model.impactfactor),
//              Text("Chief Editor: "+model.chiefeditor),
//              new Expanded(flex: 1,
//                child: new SingleChildScrollView(
//                    scrollDirection: Axis.vertical,//.horizontal
//                    child: new Text(
//                        model.description)),
//              ),
//
//              RaisedButton(
//                onPressed: () async {
//                  final String resp = await addJournal(model);
//                  showToast(context, resp);
//                },
//                child: Text("Add to reading list"),
//              )
//            ])));
//  }
//}
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Book Details"),
        ),
        drawer: AppDrawer(),
        body: Builder(
            builder: (context) => Padding(
                padding: EdgeInsets.all(25),
                child: ListView(children: [
                  Text(
                    model.name,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    Image(
                      image: NetworkImage(model.image),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
//                              ButtonTheme(
//                                minWidth: 200,
//                                textTheme: ButtonTextTheme.primary,
//                                child: RaisedButton(
//                                  onPressed: () {
//                                    showToast(context, "NOT IMPLEMENTED");
//                                  },
//                                  child: Text("Issue Book"),
//                                ),
//                              ),
                              ButtonTheme(
                                minWidth: 200,
                                textTheme: ButtonTextTheme.primary,
                                child: RaisedButton(
                                  onPressed: () async {
                                    final String resp = await addJournal(model);
                                    showToast(context, resp);
                                  },
                                  child: Text("Add to Read List"),
                                ),
                              ),
                              ButtonTheme(
                                minWidth: 200,
                                textTheme: ButtonTextTheme.primary,
                                child: RaisedButton(
                                  onPressed: () {
                                    showToast(context, "NOT IMPLEMENTED");
                                  },
                                  child: Text("Edit Information"),
                                ),
                              ),
                            ])))
                  ]),
                  SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: model.title,
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "volume: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.volume),
                          TextSpan(
                              text: "issue: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.issue)
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "date: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.date)
                        ]),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "publisher: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.name)
                        ]),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "impact factor: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.impactfactor)
                        ]),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "cheif editor: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.chiefeditor)
                        ]),
                  ),

                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "ISSN: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.issn)
                        ]),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "Description: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: model.description)
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]))));
  }
}

