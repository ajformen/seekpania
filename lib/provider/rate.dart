import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_rate.dart';

class Rate with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String rateId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  late UserAccount accUser;
  late SelectRate selectRate;

  List<SelectRate> _items = [];

  List<SelectRate> get items {
    return _items;
  }

  List<SelectRate> _userPoints = [];

  List<SelectRate> get userPoints {
    return _userPoints;
  }

  Future<void> fetchCurrentUserPoints(String currentUserID) async {
    try {
      QuerySnapshot pointsList = await usersRef.doc(currentUserID).collection('points').get();
      final extractedData = pointsList.docs.map((point) => SelectRate.fromDocument(point)).toList();
      if (extractedData == null) {
        return;
      }

      _userPoints = extractedData;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createRating(SelectRate rate, userId) async{
    accUser = UserAccount(id: userId);
    selectRate = SelectRate(id: rateId);
    DocumentSnapshot doc = await usersRef.doc(accUser.id).get();
    accUser = UserAccount.fromDocument(doc);
    try{
      double total = accUser.points! + double.parse(rate.rate.toString());
      await usersRef.doc(userId).update({
        'points': total,
      });
      usersRef.doc(userId).collection('points').doc(selectRate.id).set({
        'id': selectRate.id,
        'rate': rate.rate,
        'feedback': rate.feedback,
        'timestamp': timestamp,
      });
      final newActivity = SelectRate(
        id: selectRate.id,
        rate: rate.rate,
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