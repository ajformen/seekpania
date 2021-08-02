import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SelectMessage with ChangeNotifier {
  final String? id;
  final String? senderId;
  final String? receiverId;
  final String? senderName;
  final String? receiverName;
  final String? message;

  SelectMessage({
    this.id,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.receiverName,
    this.message,
  });

  factory SelectMessage.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return SelectMessage(
      id: d['id'],
      senderId: d['senderId'],
      receiverId: d['receiverId'],
      senderName: d['senderName'],
      receiverName: d['receiverName'],
      message: d['message'],
    );
  }

}