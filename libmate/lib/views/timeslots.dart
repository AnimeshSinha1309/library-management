import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/ticket.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TimePage extends StatefulWidget {
  final UserModel user;

  TimePage({this.user});

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  bool _loaded = false;
  Timer _timer;
  int _maxUsers = 10;
  Set<String> _filledSlots = Set();

  List<String> times = [
    '2020-08-01_09:30',
    '2020-08-01_10:00',
    '2020-08-01_10:30',
    '2020-08-01_11:00',
    '2020-08-01_11:30'
  ];

  Future getSlotList(DateTime now, DateTime end, DateFormat dateFormat) async {
    List<String> _slots = [];
    DateTime cur = now;
    while (dateFormat.format(cur).compareTo(dateFormat.format(end)) < 0) {
      _slots.add(dateFormat.format(cur));
      cur = cur.add(new Duration(minutes: 30));
    }
    setState(() {
      _loaded = true;
      times = _slots;
    });
  }

  Future getAppointments(String now) async {
    try {
      final snapShot =
          await Firestore.instance.collection('appointments').getDocuments();
      if (snapShot == null) return;
      var batch = Firestore.instance.batch();
      Set<String> _slotlist = Set();
      for (var document in snapShot.documents) {
        if (document.documentID.compareTo(now) < 0) {
          batch.delete(Firestore.instance
              .collection('appointments')
              .document(document.documentID));
        } else if (document.data['uid'].length >= _maxUsers ||
            document.data['uid'].contains(widget.user.uid)) {
          _slotlist.add(document.documentID);
        }
      }
      batch.commit();
      setState(() {
        _filledSlots = _slotlist;
        _loaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getSlots() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd_HH:mm");
    DateTime now = DateTime.now();
    DateTime cur = DateTime(
        now.year, now.month, now.day, now.hour, now.minute - now.minute % 30);
    DateTime end = cur.add(new Duration(days: 1));
    // DateTime end = DateTime(now.year, now.month, now.day, 23, 30);
    await getSlotList(cur, end, dateFormat);
    await getAppointments(dateFormat.format(cur));
  }

  @override
  void initState() {
    super.initState();
    getSlots();
    _timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      getSlots();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _timeCell(String slot) {
    return Builder(
      builder: (context) => TableCell(
          child: Center(
        child: RaisedButton(
          color:
              _filledSlots.contains(slot) == false ? Colors.green : Colors.red,
          onPressed: () async {
            bool _isAvail = !_filledSlots.contains(slot);
            if (_isAvail) {
              final snapshot = await Firestore.instance
                  .collection('appointments')
                  .document(slot)
                  .get();
              if (snapshot.exists && snapshot.data['uid'].length >= _maxUsers) {
                setState(() {
                  _filledSlots.add(slot);
                  showToast(context, "Sorry, This slot is not available now!");
                });
              } else {
                if (snapshot.exists) {
                  var newList = snapshot.data['uid'];
                  newList.add(widget.user.uid);
                  Firestore.instance
                      .collection('appointments')
                      .document(slot)
                      .updateData({'uid': newList});
                } else {
                  Firestore.instance
                      .collection('appointments')
                      .document(slot)
                      .setData({
                    'uid': [widget.user.uid]
                  });
                }
                setState(() {
                  _filledSlots.add(slot);
                });
                showToast(context, "Your Slot is booked!");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TicketPage(slot: slot)),
                );
              }
            } else {
              showToast(context, "This slot is full!");
            }
          },
          child: Text(
            slot.split('_')[0] + " " + slot.split('_')[1],
            style: TextStyle(color: Colors.white),
          ),
        ),
      )),
    );
  }

  List<TableRow> _timeRow() {
    List<TableRow> rowList = List<TableRow>();
    for (var i = 0; i < times.length; i += 2) {
      if (i + 1 >= times.length) {
        rowList.add(TableRow(
          children: [
            _timeCell(times[i]),
            _timeCell(times[i + 1]),
          ],
        ));
      } else {
        rowList.add(TableRow(
          children: [
            _timeCell(times[i]),
            _timeCell(times[i + 1]),
          ],
        ));
      }
    }
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          title: new Text('Select time'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: _loaded == false
            ? Text("loading..")
            : SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  //          defaultColumnWidth:
                  //              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
                  border: TableBorder.all(
                      color: Colors.black26, width: 1, style: BorderStyle.none),
                  children: _timeRow(),
                )));
  }
}
