import 'package:flutter/material.dart';
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
  int _maxUSers = 10;
  Set<String> _slots = Set();

  Future getAppointments() async {
    try {
      final snapShot =
          await Firestore.instance.collection('appointments').getDocuments();
      Set<String> _slotlist = Set();
      for (var document in snapShot.documents) {
        if (document.data['cnt'] >= _maxUSers) {
          _slotlist.add(document.documentID);
        }
      }
      setState(() {
        _slots = _slotlist;
        _loaded = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointments();
    _timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      getAppointments();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Iterable<TimeOfDay> getTimes(
  //     TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
  //   var hour = startTime.hour;
  //   var minute = startTime.minute;

  //   do {
  //     yield TimeOfDay(hour: hour, minute: minute);
  //     minute += step.inMinutes;
  //     while (minute >= 60) {
  //       minute -= 60;
  //       hour++;
  //     }
  //   } while (hour < endTime.hour ||
  //       (hour == endTime.hour && minute <= endTime.minute));
  // }

  // void genslots(startTime, endTime) {
  //   final step = Duration(minutes: 30);

  //   final times = getTimes(startTime, endTime, step)
  //       .map((tod) => tod.format(context))
  //       .toList();

  //   print(times);
  // }
//  final startTime = TimeOfDay(hour: 9, minute: 0);
//  final endTime = TimeOfDay(hour: 22, minute: 0);
//  genslots(startTime,endTime);

  List<String> times = [
    '2020-08-01_09:30',
    '2020-08-01_10:00',
    '2020-08-01_10:30',
    '2020-08-01_11:00',
    '2020-08-01_11:30'
  ];

  Widget _timeCell(String slot) {
    bool _isAvailable = !_slots.contains(slot);

    return TableCell(
        child: Center(
      child: RaisedButton(
        color: _isAvailable == true ? Colors.green : Colors.red,
        onPressed: () async {
          if (_isAvailable) {
            var docRef =
                Firestore.instance.collection('appointments').document(slot);
            Firestore.instance.runTransaction((transaction) {
              return transaction.get(docRef).then((doc) {
                if (doc.exists) {
                  var cnt = doc.data['cnt'];
                  if (cnt < _maxUSers) {
                    transaction.update(docRef, {
                      'cnt': cnt + 1,
                    });
                  } else {
                    _isAvailable = false;
                  }
                } else {
                  transaction.set(docRef, {
                    'cnt': 1,
                  });
                }
              });
            });
          }
          if (_isAvailable) {
            setState(() {
              _slots.add(slot);
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketPage(slot: slot)),
            );
          } else {
            showToast(context, 'Sorry, This slot is not available!');
          }
        },
        child: Text(
          slot.split('_')[1],
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
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
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  //          defaultColumnWidth:
                  //              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
                  border: TableBorder.all(
                      color: Colors.black26, width: 1, style: BorderStyle.none),
                  children: [
                    TableRow(
                      children: times.map((String slot) {
                        return _timeCell(slot);
                      }).toList(),
                    )
                  ],
                )));
  }
}
