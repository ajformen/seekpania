import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/services/message_service.dart';
import 'package:challenge_seekpania/widget/messages/notify/message_lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  late Stream<DocumentSnapshot> _chats;
  late UserAccount currentUser;

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _joinedChats();
  }

  void _joinedChats() async {
    var snapshots = MessageService(uid: user!.uid).getUserChats();
    setState(() {
      _chats = snapshots;
    });
  }

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        viewMessages(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
      child: Text(
        'Messages',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          // color: Color(0xff4e4b6f),
        ),
      ),
    );
  }

  noMessages() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any messages.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewMessages() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _chats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var chats = snapshot.data!['chats'];
        if (chats != null && chats.length != 0) {
          // String? name = currentUser.firstName;
          return ListView.builder(
            itemCount: chats.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              int reqIndex = chats.length - index -1;
              var chat = chats[reqIndex];
              return MessageLists(
                // userName: name!,
                chatId: _destructureChatId(chat),
                chatName: _destructureChatName(chat),
              );
            },
          );
        } else {
          return noMessages();
        }
      },
    );
  }

  String _destructureChatId(String res) {
    String chatId = res.substring(0, res.indexOf('_'));
    print('chatId=$chatId');
    return chatId;
  }

  String _destructureChatName(String res) {
    String name = res.substring(res.indexOf('_') + 1);
    print('name=$name');
    return name;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading ? Center(child: CircularProgressIndicator(),) : Container(
          child: display(),
        ),
      ),
    );
  }
}
