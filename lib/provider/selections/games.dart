import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/display_interests.dart';
import 'package:challenge_seekpania/models/selections/select_games.dart';
import 'package:challenge_seekpania/models/user_account.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Games with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String gameId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final gamesRef = FirebaseFirestore.instance.collection('games');
  UserAccount currentUser;
  SelectGames theGame;

  List<SelectGames> _items = [
    // SelectGames(
    //   id: 'game1',
    //   title: 'Action games',
    // ),
    // SelectGames(
    //   id: 'game2',
    //   title: 'Board games',
    // ),
    // SelectGames(
    //   id: 'game3',
    //   title: 'Browser games',
    // ),
    // SelectGames(
    //   id: 'game4',
    //   title: 'Card games',
    // ),
    // SelectGames(
    //   id: 'game5',
    //   title: 'Casino games',
    // ),
    // SelectGames(
    //   id: 'game6',
    //   title: 'First-person shooter games',
    // ),
    // SelectGames(
    //   id: 'game7',
    //   title: 'Online games',
    // ),
    // SelectGames(
    //   id: 'game8',
    //   title: 'Online poker',
    // ),
    // SelectGames(
    //   id: 'game9',
    //   title: 'Puzzle video games',
    // ),
    // SelectGames(
    //   id: 'game10',
    //   title: 'Racing games',
    // ),
    // SelectGames(
    //   id: 'game11',
    //   title: 'Shooter games',
    // ),
    // SelectGames(
    //   id: 'game12',
    //   title: 'Sports games',
    // ),
    // SelectGames(
    //   id: 'game13',
    //   title: 'Strategy games',
    // ),
    // SelectGames(
    //   id: 'game14',
    //   title: 'Video games',
    // ),
    // SelectGames(
    //   id: 'game15',
    //   title: 'Word games',
    // ),
  ];

  List<SelectGames> get items {
    return _items;
  }

  List<DisplayInterests> _gameItems = [];

  List<DisplayInterests> get gameItems {
    return _gameItems;
  }

  // List<DisplayInterests> _userGameItems = [];
  //
  // List<DisplayInterests> get userGameItems {
  //   return _userGameItems;
  // }

  SelectGames findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  // Future<void> fetchUserGameInterests(String userId) async {
  //   try {
  //     // currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
  //     // print('USER IS');
  //     // print(currentUser.id);
  //     // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
  //     QuerySnapshot gamesList = await usersRef.doc(userId).collection('interests').where('type', isEqualTo: 'games').get();
  //     final extractedData = gamesList.docs.map((game) => DisplayInterests.fromDocument(game)).toList();
  //     if (extractedData == null) {
  //       return;
  //     }
  //
  //     _userGameItems = extractedData;
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  Future<void> fetchGameInterests() async {
    try {
      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot gamesList = await usersRef.doc(currentUser.id).collection('interests').where('type', isEqualTo: 'games').get();
      final extractedData = gamesList.docs.map((game) => DisplayInterests.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _gameItems = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetGames() async {
    try {
      currentUser = UserAccount(id: user.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot snapshot = await gamesRef.orderBy('timestamp').get();
      print('VIEW DATA');
      print(snapshot);
      final extractedData = snapshot.docs.map((doc) => SelectGames.fromDocument(doc)).toList();
      if (extractedData == null) {
        return;
      }

      _items = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addGame(SelectGames game) async{
    currentUser = UserAccount(id: user.uid);
    theGame = SelectGames(id: gameId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      gamesRef.doc(theGame.id).set({
        'id': theGame.id,
        'title': game.title,
        // 'isSelected': game.isSelected,
        'creatorId': currentUser.id,
        'creator-email': currentUser.email,
        'timestamp': timestamp,
        'selects': {},
      });
      final newGame = SelectGames(
        id: theGame.id,
        title: game.title,
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

  Future<void> updateGame(String id, SelectGames newGame) async {
    final gameIndex = _items.indexWhere((game) => game.id == id);
    print(gameIndex);
    print('UPDATE GAME ID:');
    print(id);
    if (gameIndex >= 0) {
      await gamesRef.doc(id).update({
        'title': newGame.title,
      });
      _items[gameIndex] = newGame;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteGame(String id) async {
    final existingGameIndex = _items.indexWhere((game) => game.id == id);
    await gamesRef.doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    _items.removeAt(existingGameIndex);
    notifyListeners();
  }
}