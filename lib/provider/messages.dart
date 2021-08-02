import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_message.dart';

class Messages with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final activityFeedRef = FirebaseFirestore.instance.collection('feeds');
  late UserAccount currentUser;

  List<SelectMessage> _items = [];

  List<SelectMessage> get items {
    return _items;
  }

  SelectMessage findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  /// View messages
  Future<void> fetchMessages(String userId) async {
    try {
      QuerySnapshot feedsList = await usersRef.doc(userId).collection('messages').get();
      final extractedData = feedsList.docs.map((game) => SelectMessage.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _items = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}