import 'dart:convert';
import 'package:libmate/datastore/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/journals.dart';
import 'package:libmate/views/adminjournalpage.dart';
import 'package:libmate/widgets/toread.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminjournalCard extends StatelessWidget {
  final JournalModel model;
  final bool shouldOpenPage;

  AdminjournalCard({@required this.model, this.shouldOpenPage = true})
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminjournalPage(model)),
                          );
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
