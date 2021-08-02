import 'dart:convert';
import 'package:challenge_seekpania/models/selections/select_chaperone.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/display_interests.dart';
import 'package:challenge_seekpania/models/selections/select_games.dart';
import 'package:challenge_seekpania/models/user_account.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chaperones with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String gameId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final chaperoneRef = FirebaseFirestore.instance.collection('chaperones');
  late UserAccount currentUser;
  late SelectChaperone theGame;

  List<SelectChaperone> _items = [
   //
  ];

  List<SelectChaperone> get items {
    return _items;
  }

  List<SelectChaperone> _chaperoneLists = [
    //
  ];

  List<SelectChaperone> get chaperoneLists {
    return _chaperoneLists;
  }

  // List<DisplayInterests> _userGameItems = [];
  //
  // List<DisplayInterests> get userGameItems {
  //   return _userGameItems;
  // }

  SelectChaperone findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchChaperones(String currentUserID) async {
    try {
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot gamesList =
      await usersRef.doc(currentUserID).collection('chaperones').get();
      final extractedData = gamesList.docs
          .map((game) => SelectChaperone.fromDocument(game))
          .toList();
      if (extractedData == null) {
        return;
      }

      _chaperoneLists = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addChaperone(SelectChaperone game, String userId) async{
    currentUser = UserAccount(id: user!.uid);
    theGame = SelectChaperone(id: gameId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      usersRef.doc(userId).collection('chaperones').doc(theGame.id).set({
        'id': theGame.id,
        'name': game.name,
        'relationship': game.relationship,
        'timestamp': timestamp,
      });
      final newGame = SelectChaperone(
        id: theGame.id,
        name: game.name,
        relationship: game.relationship,
      );
      _items.add(newGame);
      // DocumentSnapshot res = await gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).get();
      // res = await gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).get();
      // theGame = SelectGames.fromDocument(res);
      gameId = Uuid().v4();
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // Future<void> updateGame(String id, SelectGames newGame) async {
  //   final gameIndex = _items.indexWhere((game) => game.id == id);
  //   print(gameIndex);
  //   print('UPDATE GAME ID:');
  //   print(id);
  //   if (gameIndex >= 0) {
  //     await gamesRef.doc(id).update({
  //       'title': newGame.title,
  //     });
  //     _items[gameIndex] = newGame;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

  Future<void> deleteGame(String id) async {
    final existingGameIndex = _items.indexWhere((game) => game.id == id);
    await chaperoneRef.doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    _items.removeAt(existingGameIndex);
    notifyListeners();
  }
}