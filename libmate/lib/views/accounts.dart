import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/gauth.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatefulWidget {
  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  bool loggedIn;
  List<String> displayedTags;

  @override
  void initState() {
    super.initState();
    loggedIn = false;
    displayedTags = ["Sakshi"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Accounts'),
        ),
        drawer: AppDrawer(),
        body: Consumer<UserModel>(
          builder: (context, model, child) {
            return Container(
              color: Colors.white,
              child: Center(
                // SCREEN PORTION: Account Header
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width: 75.0,
                                  height: 75.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(model.photoUrl ??
                                              "https://i.pravatar.cc/300")))),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      Text(model.name ?? "John Doe",
                                          textScaleFactor: 1.5),
                                      Text(model.email ??
                                          "test@libmate.iiit.ac.in",
                                          textScaleFactor: 1.0),
                                    ],
                                  ))
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 3,
                            ),
                          ),
                          GAuthButton(
                            callback: () {
                              model.logoutUser();
                            },
                            text: 'Sign Out',
                          ),
                        ],
                      ))),
            );
          },
        ));
  }

  /*
  Widget buildTagInput(UserModel model) {
    return Tags(
      key: _tagStateKey,
      textField: TagsTextField(
        onSubmitted: (String str) {
          setState(() {
            model.addTag(str);
          });
        },
      ),
      itemCount: model.tags.length, // required
      itemBuilder: (int index) {
        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index,
          title: model.tags.elementAt(index),
          active: true,
          removeButton: ItemTagsRemoveButton(
            onRemoved: () {
              setState(() {
                model.removeTag(index);
              });
              return true;
            },
          ),
        );
      },
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
   */
}
