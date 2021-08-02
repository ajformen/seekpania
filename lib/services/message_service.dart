import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final String? uid;
  final CollectionReference _usersRef =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference _chatsRef =
  FirebaseFirestore.instance.collection('chats');

  MessageService({this.uid});

  /// Update user data.
  Future<void> updateUserData(String fullName, String email,
      String password) async {
    return await _usersRef.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }

  /// Get user information from a provided email address.
  Future<QuerySnapshot> getUserData(String email) async {
    QuerySnapshot snapshot =
    await _usersRef.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  /// Get User Groups.
  Stream<DocumentSnapshot> getUserChats() {
    // return _usersRef.doc(uid).snapshots();
    return _usersRef.doc(uid).snapshots();
  }

  /// Create Group.
  Future<void> createChat(String userName, String chatName) async {
    DocumentReference chatDocRef = await _chatsRef.add({
      'chatName': chatName,
      'chatIcon': '',
      'admin': userName,
      'members': [],
      // 'messages': '',
      'chatId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await chatDocRef.update({
      'members': FieldValue.arrayUnion([uid! + '_' + userName]),
      'chatId': chatDocRef.id
    });

    DocumentReference userDocRef = _usersRef.doc(uid);
    return await userDocRef.update({
      'chats': FieldValue.arrayUnion([chatDocRef.id + '_' + chatName])
    });
  }

  /// Get chats of a particular group.
  Stream<QuerySnapshot> getChats(String chatId) {
    return _chatsRef.doc(chatId).collection('messages').orderBy('time').snapshots();
  }

  /// Send chat message.
  void sendMessage(String chatId, Map<String, dynamic> chatMsgData) {
    _chatsRef.doc(chatId).collection('messages').add(chatMsgData);
    _chatsRef.doc(chatId).update({
      'recentMessage': chatMsgData['message'],
      'recentMessageSender': chatMsgData['sender'],
      'recentMessageTime': chatMsgData['time'].toString(),
    });
  }

  /// Search chat by activity name or caption.
  Future<QuerySnapshot> searchChat(String chatName) {
    return _chatsRef.where('chatName', isEqualTo: chatName).get();
  }

  /// User joined the chat
  Future<void> joinChat(String chatId, String chatName, String userName) async {
    DocumentReference userDocRef = _usersRef.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    DocumentReference chatDocRef = _chatsRef.doc(chatId);
    final d = userDocSnapshot.data() as Map;
    List<dynamic> chats = await d['chats'];
    String chat = chatId + '_' + chatName;
    String member = uid! + '_' + userName;

    if (chats.contains(chat)) {
      await userDocRef.update({
        'chats': FieldValue.arrayRemove([chat])
      });

      await chatDocRef.update({
        'members': FieldValue.arrayRemove([member])
      });
    } else {
      await userDocRef.update({
        'chats': FieldValue.arrayUnion([chat])
      });

      await chatDocRef.update({
        'members': FieldValue.arrayUnion([member])
      });
    }
  }

  Future<void> deleteMessage(String chatId, String chatName) async {
    String chat = chatId + '_' + chatName;
    //
    await _usersRef.doc(uid).update({
      'chats': FieldValue.arrayRemove([chat])
    });
    // notifyListeners();
  }

}