import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/razorpay.dart';
class IssuedBookCard extends StatelessWidget {
  final BorrowBookModel model;
  bool shouldOpenPage;

  IssuedBookCard({Key key, @required this.model, this.shouldOpenPage}) : super(key: key) {
    shouldOpenPage = shouldOpenPage ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = 200;
    final today = DateTime.now();
    final fine = today.difference(model.dueDate).inDays * model.fine;

    return Card(
      elevation: 5,
      child: InkWell(
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white,
          onTap: () {
            if (shouldOpenPage) gotoPage(context, BookPage(model: model));
          },
          child: Row(children: [
            Expanded(
              flex: 3,
              child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(model.image),
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: height,
                padding: EdgeInsets.all(8),
                color: Color.fromRGBO(100, 100, 100, 0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      model.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      model.author,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Borrowed Date: " + model.borrowDate.toString().split(' ')[0],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Due Date: " + model.dueDate.toString().split(' ')[0],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Pending Fine: " + fine.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}

class BookPage extends StatelessWidget {
  final BorrowBookModel model;

  BookPage({@required this.model});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final latedays = today.difference(model.dueDate).inDays;
    final fine = latedays * model.fine;

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Issued Book"),
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          IssuedBookCard(model: model),
          Text("Total fine is $fine"),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: RaisedButton.icon(

                    color: Colors.amber,
                    icon: Icon(Icons.launch),
                    label: Text('Pay fine'),
                    onPressed: () {
                          print("Added");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>new RazorPayPage()),
                          );
                        },
                  ),
                ),


                Center(
                  child: RaisedButton.icon(
                    onPressed: (){},
                    color: Colors.amber,
                    icon: Icon(Icons.launch),
                    label: Text('Return'),
                  ),
                ),
                Center(
                  child: RaisedButton.icon(
                    onPressed: (){},
                    color: Colors.amber,
                    icon: Icon(Icons.swap_horiz),
                    label: Text('Re-issue'),
                  ),
                ),
         ] )
        ]));
  }
}
