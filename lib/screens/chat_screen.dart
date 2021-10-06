import 'dart:developer';

import 'package:chat/widgets/messages.dart';
import 'package:chat/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState(){
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.configure(
      onMessage: (msg) {
        print('onMessage...');
        print('msg');
        return;
      },
      onResume: (msg) {
        print('onResume...');
        print('msg');
        return;
      },
      onLaunch: (msg) {
        print('onLaunch...');
        print('msg');
        return;
      },
    );
    fbm.subscribeToTopic('chat');
    fbm.requestNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (item) {
                if (item == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: Messages()),
              NewMessage(),
            ],
          ),
        ),
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      //   builder: (ctx, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     final documents = snapshot.data.docs;

      //     return ListView.builder(
      //       itemCount: documents.length,
      //       itemBuilder: (ctx, i) => Container(
      //         padding: EdgeInsets.all(8),
      //         child: Text(documents[i]['text']),
      //       ),
      //     );
      //   },
      // ),

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      // WidgetsFlutterBinding.ensureInitialized();
      // Firebase.initializeApp();
      // FirebaseFirestore.instance
      //     .collection('chat')
      //     .snapshots()
      //     .listen((querySnapshot) {
      //   //print(querySnapshot.docs[1]['text']);
      //   querySnapshot.docs.forEach((element) {
      //     print(element['text']);
      //   });
      // });
      //     FirebaseFirestore.instance.collection('chat').add({
      //       'text': 'Adicionado manualmente!',
      //       //'flutter': true,
      //     });
      //   },
      // ),
    );
  }
}
