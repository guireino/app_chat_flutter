import 'package:chat/screens/chat_screen.dart';
import 'package:chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          // ignore: missing_return
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            // WidgetsFlutterBinding.ensureInitialized();
            // Firebase.initializeApp();
            final chatDocs = chatSnapshot.data.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, i) => MessageBubble(
                chatDocs[i].get('text'),
                chatDocs[i].get('userName'),
                chatDocs[i].get('userImage'),
                chatDocs[i].get('userId') == user.uid,
                key: ValueKey(chatDocs[i].documentID),
              ),
            );
          },
        );
    }
}