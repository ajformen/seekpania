import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_message.dart';
import 'package:challenge_seekpania/widget/messages/message_tile.dart';
import 'package:challenge_seekpania/services/message_service.dart';

class MessageChatScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String chatName;

  MessageChatScreen({
    required this.chatId,
    required this.userName,
    required this.chatName,
  });

  @override
  _MessageChatScreenState createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  late UserAccount currentUser;
  late SelectMessage msg;
  late Stream<QuerySnapshot> _chats;
  TextEditingController msgEditingController = TextEditingController();
  late String name, senderId, msgId;

  @override
  void initState() {
    super.initState();

    var chats = MessageService().getChats(widget.chatId);
    setState(() {
      _chats = chats;
    });
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName, style: TextStyle(color: Colors.white, fontSize: 14.0)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _buildChatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: msgEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        var chats = snapshot.data!.docs;
        return Container(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index].data() as Map;
              return MessageTile(
                message: chat['message'],
                sender: chat['sender'],
                sentByMe: widget.userName == chat['sender'],
              );
            },
          ),
        );
      },
    );
  }

  _sendMessage() {
    if (msgEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMsgData = {
        'message': msgEditingController.text,
        'sender': widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      MessageService().sendMessage(widget.chatId, chatMsgData);

      setState(() {
        msgEditingController.text = '';
      });
    }
  }
}
