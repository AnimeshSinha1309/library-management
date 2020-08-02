import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/issueitem.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:libmate/datastore/state.dart';
import 'dart:convert';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
class BookedTicketPage extends StatefulWidget {
  final String slot;
  final int tableNo;
  final int type;
  String qrdata;
  String uid;
  UserModel user;

  TicketPage(this.user,this.slot, this.tableNo,this.type){
    List<dynamic> datalist = [];
    if(user.email != null)
    {
      uid = user.email;
      datalist.add(user.email);
    }
    datalist.add({'slot': slot});
    qrdata = jsonEncode(datalist);
    qrdata = jsonEncode(datalist);

    printWrapped(qrdata);
  }

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String time;
  String date;
  int tableNo;
  int type;

  _TicketPageState();
  @override
  void initState() {
    super.initState();
    date = widget.slot.split('_')[0];
    time = widget.slot.split('_')[1];
    tableNo = widget.tableNo;
    type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    if(type==1)
    {
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


                        Text('$date',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                            )),

                        QrImage(data: widget.qrdata, version: QrVersions.auto, size: 200.0),
                        Text("Show this QR code to the library admin"),
                        Text("Not received confirmation from admin yet")


                      ]
                  )
              ),
            );
            var tableGroup = SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 30.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Sit in Library',
                            style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)),

                        Text('\n Table Number: $tableNo',
                            style: TextStyle(
                                color: Colors.pink,
                                letterSpacing: 2.0,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                            )),
                      ]
                  )
              ),
            );


            return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: new AppBar(
                  title: new Text('Ticket'),
                  centerTitle: true,
                ),
                drawer: AppDrawer(),
                body: CustomScrollView(
                  slivers: [statsGroup, tableGroup],
                ));
          });
    }
    else{
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



                        Text('$date',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                            )),
                        Row(
                            children: <Widget>[
                              Text('\n\n Issue/Return book',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 2.0,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                            ]),
                        QrImage(data: widget.qrdata, version: QrVersions.auto, size: 200.0),
                        Text("Show this QR code to the library admin"),
                        Text("Not received confirmation from admin yet")



                      ]
                  )
              ),
            );

            return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: new AppBar(
                  title: new Text('Ticket'),
                  centerTitle: true,
                ),
                drawer: AppDrawer(),
                body: CustomScrollView(
                  slivers: [statsGroup],
                ));
          });
    }

  }
}
