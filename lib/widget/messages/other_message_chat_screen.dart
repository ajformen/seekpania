import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_message.dart';
import 'package:challenge_seekpania/widget/messages/message_tile.dart';
import 'package:challenge_seekpania/services/message_service.dart';

class OtherMessageChatScreen extends StatefulWidget {
  final String id;
  final String firstName;

  OtherMessageChatScreen({
    required this.id,
    required this.firstName,
  });

  @override
  _OtherMessageChatScreenState createState() => _OtherMessageChatScreenState();
}

class _OtherMessageChatScreenState extends State<OtherMessageChatScreen> {
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

    var chats = MessageService().getChats(widget.id);
    print('USER ID');
    print(widget.id);
    setState(() {
      _chats = chats;
    });
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    print('CURRENT USER ID:');
    print(currentUser.id);
    return FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(currentUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buildLoading();
          }
          currentUser = UserAccount.fromDocument(snapshot.data!);
          print('CURRENT USER NAME');
          print(currentUser.firstName);
          name = currentUser.firstName!;
          senderId = currentUser.id!;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.firstName, style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.black87,
              elevation: 0.0,
            ),
            body: Container(
              child: Stack(
                children: <Widget>[
                  _buildChatMessages(name),
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
                              _sendMessage(name, senderId, widget.firstName);
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
    );
  }

  Widget _buildChatMessages(String name) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        var chats = snapshot.data!.docs;
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            var chat = chats[index].data() as Map;
            return MessageTile(
              message: chat['message'],
              sender: chat['sender'],
              sentByMe: name == chat['sender'],
            );
          },
        );
      },
    );
  }

  _sendMessage(String name, String senderId, String receiverName) {
    if (msgEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMsgData = {
        'message': msgEditingController.text,
        'senderName': name,
        'receiverName': receiverName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      setState(() {
        msgEditingController.text = '';
      });
    }
  }
}
