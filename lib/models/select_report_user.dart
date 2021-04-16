import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SelectReportUser with ChangeNotifier {
  final String? id;
  final String? feedback;
  final String? reportedUserId;
  final String? reportedUserName;
  final String? senderId;
  final String? senderName;
  final String? senderEmail;

  SelectReportUser({
    this.id,
    this.feedback,
    this.reportedUserId,
    this.reportedUserName,
    this.senderId,
    this.senderName,
    this.senderEmail,
  });

  factory SelectReportUser.fromDocument(DocumentSnapshot doc) {
    final d = doc.data();
    return SelectReportUser(
      id: d!['id'],
      feedback: d['feedback'],
      reportedUserId: d['reportedUserId'],
      reportedUserName: d['reportedUserName'],
      senderId: d['senderId'],
      senderName: d['senderName'],
      senderEmail: d['senderEmail'],
    );
  }

}