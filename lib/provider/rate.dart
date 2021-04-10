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
  UserAccount currentUser;
  SelectRate selectRate;

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
    currentUser = UserAccount(id: user.uid);
    selectRate = SelectRate(id: rateId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      // usersRef.doc(currentUser.id).collection('activities').doc(userId).collection('invitation').doc(selectInvite.id).set({
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