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
import 'package:libmate/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class AdminjournalPage extends StatefulWidget {
  final JournalModel model;
  AdminjournalPage(this.model);
  @override
  _AdminjournalPageState createState() => _AdminjournalPageState();
}
class _AdminjournalPageState extends State<AdminjournalPage> {

  int maxBooks = 20;
  String _docType;

//  Future renew(name) async {
//    Firestore.instance.collection('periodical-subscriptions').document(name).get().then((value){
//      print(value.data);
//    });
//  }
  @override
  void initState() {
    super.initState();
    _docType = 'periodical-subscriptions';

  }

  Future renewPeriodicals(String name,String type) async {
    int months;
    switch(type) {
      case 'annually': {
        months = 12;
      }
      break;

      case 'semi-annually': {
        months = 6;
      }
      break;
      case 'quaterly': {
        months = 4;
      }
      break;
      case 'monthly': {
        months = 1;
      }
      break;

      default: {
        months =1;
      }
      break;
    }
    final snapshot = await Firestore.instance
        .collection(_docType)
        .document(name)
        .get();

    print(snapshot.data['expiry']);
    var currDt = DateTime.now();
        if(currDt.isAfter(snapshot.data['expiry']))
          {
            showToast(context, "Already subscribed!");
          }
        else{
          var purchase = DateTime.now();
          var expiry = DateTime.now().add(Duration(days: 30*months));
          Firestore.instance
              .collection(_docType)
              .document(name)
              .updateData({'purchased': purchase});
          Firestore.instance
              .collection(_docType)
              .document(name)
              .updateData({'expiry': expiry});
          showToast(context, "Renewed, payment charged from your saved account details");
        }
  }
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
  List<String> _subscription = ['annually', 'semi-annually', 'quaterly', 'monthly']; // Option 2
  String _currsubscription = 'annually';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Journal Details"),
        ),
        drawer: AppDrawer(),
        body: Builder(
            builder: (context) => Padding(
                padding: EdgeInsets.all(25),
                child: ListView(children: [
                  Text(
                    widget.model.name,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    Image(
                      image: NetworkImage(widget.model.image),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [

                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Subscription type: ",
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                              DropdownButton(
                                hint: Text('Subscription type'), // Not necessary for Option 1
                                value: _currsubscription,
                                onChanged: (newValue) {
                                  setState(() {
                                    _currsubscription = newValue;
                                  });
                                },
                                items: _subscription.map((subscription) {
                                  return DropdownMenuItem(
                                    child: new Text(subscription),
                                    value: subscription,
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Charges: ",
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: widget.model.charges)
                                    ]),
                              ),
                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Expires: "+ "23-07-2020",
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                              ButtonTheme(
                                minWidth: 200,
                                textTheme: ButtonTextTheme.primary,
                                child: RaisedButton(
                                  onPressed: () async {
                                    showToast(context, "Please wait..");
                                    print(widget.model.name);
                                    await renewPeriodicals(widget.model.name,'annually');
                                  },
                                  child: Text("Renew subscription"),
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
                              text: widget.model.title,
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
                          TextSpan(text: widget.model.volume),
                          TextSpan(
                              text: "issue: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.model.issue)
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "date: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.model.date)
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
                          TextSpan(text: widget.model.name)
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
                          TextSpan(text: widget.model.impactfactor)
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
                          TextSpan(text: widget.model.chiefeditor)
                        ]),
                  ),

                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: "ISSN: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.model.issn)
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
                          TextSpan(text: widget.model.description)
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]))));
  }
}

