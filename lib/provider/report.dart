import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_report_user.dart';

class Report with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String rateId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final reportUsersRef = FirebaseFirestore.instance.collection('reportedUsers');
  late UserAccount currentUser;
  late SelectReportUser selectReport;

  List<SelectReportUser> _items = [];

  List<SelectReportUser> get items {
    return _items;
  }

  Future<void> createReport(SelectReportUser report, userId, userName) async{
    currentUser = UserAccount(id: user!.uid);
    selectReport = SelectReportUser(id: rateId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      reportUsersRef.doc(selectReport.id).set({
        'id': selectReport.id,
        'feedback': report.feedback,
        'reportedUserId': userId,
        'reportedUserName': userName,
        'senderId': currentUser.id,
        'senderName': currentUser.firstName,
        'senderEmail': currentUser.email,
        'timestamp': timestamp,
      });
      final newActivity = SelectReportUser(
        id: selectReport.id,
      );
      _items.add(newActivity);
      rateId = Uuid().v4();
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

}