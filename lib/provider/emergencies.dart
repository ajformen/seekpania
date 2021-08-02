import 'package:challenge_seekpania/models/selections/select_emergency.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Emergencies with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String gameId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final emergencyRef = FirebaseFirestore.instance.collection('emergencies');
  late UserAccount currentUser;
  late SelectEmergency theGame;

  List<SelectEmergency> _items = [
    //
  ];

  List<SelectEmergency> get items {
    return _items;
  }

  List<SelectEmergency> _emergencyLists = [
    //
  ];

  List<SelectEmergency> get emergencyLists {
    return _emergencyLists;
  }

  SelectEmergency findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchEmergencies(String currentUserID) async {
    try {
      QuerySnapshot gamesList =
      await usersRef.doc(currentUserID).collection('emergencies').get();
      final extractedData = gamesList.docs
          .map((game) => SelectEmergency.fromDocument(game))
          .toList();
      if (extractedData == null) {
        return;
      }

      _emergencyLists = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addEmergency(SelectEmergency game, String userId) async{
    currentUser = UserAccount(id: user!.uid);
    theGame = SelectEmergency(id: gameId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      usersRef.doc(userId).collection('emergencies').doc(theGame.id).set({
        'id': theGame.id,
        'name': game.name,
        'relationship': game.relationship,
        'email': game.email,
        'timestamp': timestamp,
      });
      final newGame = SelectEmergency(
        id: theGame.id,
        name: game.name,
        relationship: game.relationship,
        email: game.email,
      );
      _items.add(newGame);
      gameId = Uuid().v4();
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteGame(String id) async {
    final existingGameIndex = _items.indexWhere((game) => game.id == id);
    await emergencyRef.doc(id).delete();
    _items.removeAt(existingGameIndex);
    notifyListeners();
  }
}