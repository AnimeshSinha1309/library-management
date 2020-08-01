import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/views/ticket.dart';
class TimePage extends StatefulWidget {
  var  day;
  var option;
  var date;
  TimePage(this.date,this.option,this.day);

  @override
  _TimePageState createState() => _TimePageState(date,option,day);
}

class _TimePageState extends State<TimePage> {
  var  day;
  var option;
  var date;
  var bookdate, time;
  _TimePageState(this.date,this.option,this.day);

  Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;
    @override
    void initState() {
      super.initState();
    }
    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }
  void genslots(startTime,endTime){
    final step = Duration(minutes: 30);

    final times = getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();

    print(times);
  }
//  final startTime = TimeOfDay(hour: 9, minute: 0);
//  final endTime = TimeOfDay(hour: 22, minute: 0);
//  genslots(startTime,endTime);

  List<String> times = ['9:30 AM','10:00 AM','10:30 AM','11:00 AM','11:30 AM'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          title: new Text('Select time'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body:

        Padding(

        padding: const EdgeInsets.all(8.0),
        child: Table(

            //          defaultColumnWidth:
            //              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
                border: TableBorder.all(
                color: Colors.black26, width: 1, style: BorderStyle.none),
                children: [

                TableRow(children: [
                TableCell(child: Center(child: RaisedButton(
                              color: Colors.red,
                              onPressed: (){},
                              child: Text(
                              '11 am',
                              style: TextStyle(color: Colors.white),
                              ),
                              ),)),
                  TableCell(child: Center(child: RaisedButton(
                    color: Colors.green,
                    onPressed: (){},
                    child: Text(
                      '12 am',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),)),
                  TableCell(child: Center(child: RaisedButton(
                    color: Colors.green,
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicketPage(bookdate,time)),
                      );
                    },
                    child: Text(
                      '1 pm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),)),
                  TableCell(child: Center(child: RaisedButton(
                    color: Colors.green,
                    onPressed: (){},
                    child: Text(
                      '2 pm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),)),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: RaisedButton(
                    color: Colors.red,
                    onPressed: (){},
                    child: Text(
                      '3 pm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),)),
                  TableCell(child: Center(child: RaisedButton(
                    color: Colors.green,
                    onPressed: (){},
                    child: Text(
                      '11 am',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),)),
                  TableCell(child: Center(child: RaisedButton(
                    color: Colors.green,
                    onPressed: (){},
                    child: Text(
                      '4 pm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),)),
                  TableCell(child: Center(child: RaisedButton(
                    color: Colors.red,
                    onPressed: (){},
                    child: Text(
                      '5 pm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),)),
                ])
                ],


    )));
  }
}