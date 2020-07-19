import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new AppBar(
          title: new Text('About'),
          centerTitle: true,

        ),
        drawer: AppDrawer(),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0,40.0,30.0,0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Developed by team Occam's Razor",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  Text(
                      "SIH 2020",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:10.0),
                  Text(
                      'LibMate: Smart Library management system',
                      style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 2.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold

                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'Voice assistant that guides you from aisle to aisle of the library, seamlessly through your smartphone. It automatically broadens and simplifies the topic of the conversation as you talk to it.',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'We Scrape Wikidata, Wikipedia, and Publisher websites, as well as, use Google Books API and SparQL, to get the data on each book i.e. its Category Tags, Summary, Author, Publisher, Publish Date, etc. All this is cached in an offline Database.',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),
                  SizedBox(height:30.0),
                  Text(
                      'We will also expose API for publishers and users to directly contribute information. This will come with a Clean UI for the Librarian.',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      )
                  ),



                ]
            )
        )

    );
  }
}
