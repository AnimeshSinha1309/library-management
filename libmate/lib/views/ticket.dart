import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
const directoryName = 'Signature';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
class TicketPage extends StatefulWidget {
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

  }

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String time;
  String date;
  int tableNo;
  int type;
  GlobalKey globalKey = GlobalKey();


  Future _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();

    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng();
    }

    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }



  void _printPngBytes() async {
    var pngBytes = await _capturePng();
    var bs64 = base64Encode(pngBytes);
    print(pngBytes);
    print(bs64);

// Use plugin [path_provider] to export image to storage
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);

// create directory on external storage
    await Directory('$path/$directoryName').create(recursive: true);

// write to storage as a filename.png
    File('$path/$directoryName/ticket.png')
        .writeAsBytesSync(pngBytes.buffer.asInt8List());
  }


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
        return RepaintBoundary(
            key: globalKey,
            child: Consumer<UserModel>(
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
              var printGroup = SliverToBoxAdapter(
                child: RaisedButton(
                  child: const Text('Print'),
                  onPressed: _printPngBytes),
              );
              return Scaffold(
                  backgroundColor: Colors.grey[100],
                  appBar: new AppBar(
                    title: new Text('Ticket'),
                    centerTitle: true,
                  ),
                  drawer: AppDrawer(),
                  body: CustomScrollView(
                    slivers: [statsGroup, tableGroup,printGroup],
                  ));
            }));
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
                      ]
                  )
              ),
            );
            var printGroup = SliverToBoxAdapter(
              child: RaisedButton(
                  child: const Text('Print Screenshot'),
                  onPressed: _printPngBytes),
            );

            return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: new AppBar(
                  title: new Text('Ticket'),
                  centerTitle: true,
                ),
                drawer: AppDrawer(),
                body: CustomScrollView(
                  slivers: [statsGroup,printGroup],
                ));
          });
    }

  }
}
