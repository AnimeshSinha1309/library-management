import 'dart:async';
import 'dart:io';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/datastore/model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

class GuidePage extends StatefulWidget {
  UserModel currentUser;
  GuidePage({@required this.currentUser});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GuidePage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  ChatUser user;
  final ChatUser otherUser = ChatUser(
    name: "LibMate",
    uid: "25649654",
  );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  @override
  void initState() {
    super.initState();
    user = ChatUser(
      name: widget.currentUser.name,
      uid: "12345678",
      avatar: widget.currentUser.photoUrl,
    );
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) {
    print(message.toJson());
    setState(() {
      messages.add(message);
      print(messages);
    });

    /* setState(() {
      messages = [...messages, message];
      print(messages.length);
    });

    if (i == 0) {
      systemMessage();
      Timer(Duration(milliseconds: 600), () {
        systemMessage();
      });
    } else {
      systemMessage();
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Guide"),
        ),
        drawer: AppDrawer(),
        body: DashChat(
          key: _chatViewKey,
          inverted: false,
          onSend: onSend,
          sendOnEnter: true,
          textInputAction: TextInputAction.send,
          user: user,
          inputDecoration:
              InputDecoration.collapsed(hintText: "Add message here..."),
          dateFormat: DateFormat('yyyy-MMM-dd'),
          timeFormat: DateFormat('HH:mm'),
          messages: messages,
          showUserAvatar: true,
          showAvatarForEveryMessage: false,
          scrollToBottom: true,
          onPressAvatar: (ChatUser user) {
            print("OnPressAvatar: ${user.name}");
          },
          onLongPressAvatar: (ChatUser user) {
            print("OnLongPressAvatar: ${user.name}");
          },
          inputMaxLines: 5,
          messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
          alwaysShowSend: true,
          inputTextStyle: TextStyle(fontSize: 16.0),
          inputContainerStyle: BoxDecoration(
            border: Border.all(width: 0.0),
            color: Colors.white,
          ),
          // onQuickReply: (Reply reply) {
          //   setState(() {
          //     messages.add(ChatMessage(
          //         text: reply.value, createdAt: DateTime.now(), user: user));

          //     messages = [...messages];
          //   });

          //   Timer(Duration(milliseconds: 300), () {
          //     _chatViewKey.currentState.scrollController
          //       ..animateTo(
          //         _chatViewKey
          //             .currentState.scrollController.position.maxScrollExtent,
          //         curve: Curves.easeOut,
          //         duration: const Duration(milliseconds: 300),
          //       );

          //     if (i == 0) {
          //       systemMessage();
          //       Timer(Duration(milliseconds: 600), () {
          //         systemMessage();
          //       });
          //     } else {
          //       systemMessage();
          //     }
          //   });
          // },
          onLoadEarlier: () {
            print("loading dash chat...");
          },
          shouldShowLoadEarlier: false,
          showTraillingBeforeSend: true,
          trailing: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () {
                print("No idea what this does");
                ;
              },
            )
          ],
        ));
  }
}
