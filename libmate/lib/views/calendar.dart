import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/gauth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Meeting> meetings;
  JournalModel model;
  String _docType = 'periodical_subscriptions';
  List<String> periodicals = [];
  List<DateTime> timestamps = [];

  bool isLoaded = false;

  Future loadData() async {
    List meeting = <Meeting>[];
    fetchdata();
    await Firestore.instance
        .collection('periodical_subscriptions')
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        final DateTime today = DateTime.now();
        var arr = result.data['purchased'].split('-');
        final DateTime startTime = DateTime(
            int.parse(arr[0]), int.parse(arr[1]), int.parse(arr[2]), 9, 0, 0);
        final DateTime endTime = startTime.add(const Duration(hours: 2));
        meeting.add(Meeting(result.data['name'], startTime, endTime,
            const Color(0xFF0F8644), false));
      });
    });
    setState(() {
      isLoaded = true;
      meetings = meeting;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Upcoming periodicals'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: isLoaded == false
            ? Text('loading..')
            : SfCalendar(
                view: CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource()),

                // by default the month appointment display mode set as Indicator, we can
                // change the display mode as appointment using the appointment display mode
                // property
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ));
  }

  Future addDue() async {
    try {
      final snapShot = await Firestore.instance
          .collection('periodical_subscriptions')
          .getDocuments();
      if (snapShot == null) return;
      var batch = Firestore.instance.batch();
      for (var document in snapShot.documents) {
        periodicals.add(document.data['name']);
        timestamps.add(document.data['purchased']);
        DateTime now = DateTime.now();
        timestamps.add(now);
        print(periodicals);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void fetchdata() async {
    //not used: testing
    var result = await Firestore.instance
        .collection("'periodical_subscriptions'")
        .getDocuments();
    result.documents.forEach((res) {
      print(res.data);
    });
  }

  List<Meeting> _getDataSource() {
    return meetings;
    // List meetings = <Meeting>[];
    // fetchdata();
    // Firestore.instance
    //     .collection('periodical_subscriptions')
    //     .getDocuments()
    //     .then((querySnapshot) {
    //   querySnapshot.documents.forEach((result) {
    //     final DateTime today = DateTime.now();
    //     var arr = result.data['purchased'].split('-');
    //     final DateTime startTime = DateTime(
    //         int.parse(arr[0]), int.parse(arr[1]), int.parse(arr[2]), 9, 0, 0);
    //     final DateTime endTime = startTime.add(const Duration(hours: 2));
    //     meetings.add(Meeting(result.data['name'], startTime, endTime,
    //         const Color(0xFF0F8644), false));
    //   });
    // });
    // final DateTime today = DateTime.now();
    // final DateTime startTime =
    // DateTime(today.year, today.month, today.day, 9, 0, 0);
    // final DateTime startTime2 =
    // DateTime(today.year, today.month, today.day+5, 9, 0, 0);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    // final DateTime endTime2 = startTime2.add(const Duration(hours: 2));
    // print(meetings.length);
    // meetings.add(Meeting(
    //     "Nature vol 8", startTime, endTime, const Color(0xFF0F8644), false));
    // meetings.add(Meeting(
    //     "Friction", startTime2, endTime2, const Color(0xFF0F8644), false));
    // meetings.add(Meeting(
    //     "Journal of Biomedical Sciences", startTime2, endTime2, const Color(0xFF0F8644), false));
    // return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class Record {
  final String name;
  final DateTime date;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        date = map['date'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$date>";
}
