import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/issueitem.dart';
import 'package:provider/provider.dart';

class TicketPage extends StatefulWidget {
  final String slot;
  final int tableNo;

  TicketPage({this.slot, this.tableNo});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String time;
  String date;
  int tableNo;

  @override
  void initState() {
    super.initState();
    date = widget.slot.split('_')[0];
    time = widget.slot.split('_')[1];
    tableNo = widget.tableNo;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (BuildContext context, UserModel model, Widget child) {
          var statsGroup = SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: [
                        Text('Slot booked',
                            style: TextStyle(
                                color: Colors.black87,
                                letterSpacing: 2.0,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                        Column(children: [
                          Text('Time',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                              )),
                          Text('$time',
                              style: TextStyle(
                                  color: Colors.pinkAccent,
                                  letterSpacing: 2.0,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold)),
                        ])
                      ]),
                      Row(children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Colors.grey[400],
                        ),
                        Text('Date',
                            style: TextStyle(
                                color: Colors.grey[600],
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold)),
                      ]),

                      Column(
                        children: <Widget>[
                          Text('$date\n\nTable Number: $tableNo',
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                              )),

                        ],
                      ),
                    ]
                )
            ),
          );

          var dueBooks = SliverList(
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                    IssuedBookCard(model: model.borrowedBooks[index]),
                childCount: model.borrowedBooks.length),
          );
          var pastBooks = SliverList(
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                    IssuedBookCard(model: model.borrowedBooks[index]),
                childCount: model.pastBooks.length),
          );

          return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: new AppBar(
                title: new Text('Ticket'),
                centerTitle: true,
              ),
              drawer: AppDrawer(),
              body: CustomScrollView(
                slivers: [statsGroup, dueBooks, pastBooks],
              ));
        });
  }
}
