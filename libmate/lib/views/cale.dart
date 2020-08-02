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

class _SchedulePageState extends State<SchedulePage > {
  List<Due> Dues;
  JournalModel model;
  String _docType = 'Periodical-subscription';
  List<String> periodicals = [];
  List<DateTime> timestamps = [];
  Future addDue() async {
    try {
      final snapShot =
      await Firestore.instance.collection(_docType).getDocuments();
      if (snapShot == null) return;
      var batch = Firestore.instance.batch();
      for (var document in snapShot.documents) {
        periodicals.add(document.data['name']);
//        timestamps.add(document.data['purchased']);
        DateTime now = DateTime.now();
        timestamps.add(now);
      }
    }
    catch (e) {
      print(e.toString());
    }

  }
  @override
  void initState() {
    super.initState();
    _docType = 'Periodical-subscription';
    addDue();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Upcoming periodicals dues'),
          centerTitle: true,

        ),
        drawer: AppDrawer(),
        body: SfCalendar(
          view: CalendarView.month,
          dataSource: DueDataSource(_getDataSource("Nature vol8",DateTime.now())),
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display mode
          // property
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ));
  }

  List<Due> _getDataSource(periodicals,timestamps) {
    Dues = <Due>[];
    for (var i=0; i< periodicals.length;i++) {
      Dues.add(Due(
          periodicals[i],DateTime.now(),const Color(0xFF0F8644)));
    }

    return Dues;
  }
}

class DueDataSource extends CalendarDataSource {
  DueDataSource(List<Due> source) {
    appointments = source;
  }

//  @override
//  DateTime getStartTime(int index) {
//    return appointments[index].from;
//  }
//
//  @override
//  DateTime getEndTime(int index) {
//    return appointments[index].to;
//  }

  @override
  String getSubject(int index) {
    return appointments[index].periodicalName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

}

class Due {
  Due(this.periodicalName, this.due,this.background);
  String periodicalName;
  DateTime due;
  Color background;

}