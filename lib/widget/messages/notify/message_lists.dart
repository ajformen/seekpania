import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/services/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/widget/messages/message_chat_screen.dart';

class MessageLists extends StatelessWidget {
  final String chatId;
  final String chatName;

  MessageLists({
    required this.chatId,
    required this.chatName,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(chatId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: 20.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to delete this conversation?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        final user = FirebaseAuth.instance.currentUser;
        MessageService(uid: user!.uid).deleteMessage(chatId, chatName);
      },
      child: GestureDetector(
        onTap: () async{
          UserAccount currentUser;
          final user = FirebaseAuth.instance.currentUser;
          final usersRef = FirebaseFirestore.instance.collection('users');
          currentUser = UserAccount(id: user!.uid);
          DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
          currentUser = UserAccount.fromDocument(doc);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageChatScreen(
                chatId: chatId,
                userName: currentUser.firstName!,
                chatName: chatName,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.blueAccent,
              child: Text(
                chatName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(chatName, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
