import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/display_interests.dart';
import 'package:challenge_seekpania/models/selections/select_music.dart';
import 'package:challenge_seekpania/models/user_account.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Musics with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String musicId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final musicRef = FirebaseFirestore.instance.collection('music');
  UserAccount currentUser;
  SelectMusic theMusic;

  List<SelectMusic> _items = [
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

  List<SelectMusic> get items {
    return _items;
  }

  List<DisplayInterests> _musicItems = [];

  List<DisplayInterests> get musicItems {
    return _musicItems;
  }

  // List<DisplayInterests> _userGameItems = [];
  //
  // List<DisplayInterests> get userGameItems {
  //   return _userGameItems;
  // }

  SelectMusic findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchMusicInterests() async {
    try {
      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot gamesList = await usersRef.doc(currentUser.id).collection('interests').where('type', isEqualTo: 'music').get();
      final extractedData = gamesList.docs.map((game) => DisplayInterests.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _musicItems = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetMusic() async {
    try {
      currentUser = UserAccount(id: user.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot snapshot = await musicRef.orderBy('timestamp').get();
      print('VIEW DATA');
      print(snapshot);
      final extractedData = snapshot.docs.map((doc) => SelectMusic.fromDocument(doc)).toList();
      if (extractedData == null) {
        return;
      }

      _items = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addMusic(SelectMusic music) async{
    currentUser = UserAccount(id: user.uid);
    theMusic = SelectMusic(id: musicId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      musicRef.doc(theMusic.id).set({
        'id': theMusic.id,
        'title': music.title,
        // 'isSelected': game.isSelected,
        'creatorId': currentUser.id,
        'creator-email': currentUser.email,
        'timestamp': timestamp,
        'selects': {},
      });
      final newMusic = SelectMusic(
        id: theMusic.id,
        title: music.title,
      );
      _items.add(newMusic);
      // DocumentSnapshot res = await gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).get();
      // res = await gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).get();
      // theGame = SelectGames.fromDocument(res);
      musicId = Uuid().v4();
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateMusic(String id, SelectMusic newMusic) async {
    final musicIndex = _items.indexWhere((music) => music.id == id);
    print(musicIndex);
    print('UPDATE GAME ID:');
    print(id);
    if (musicIndex >= 0) {
      await musicRef.doc(id).update({
        'title': newMusic.title,
      });
      _items[musicIndex] = newMusic;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteMusic(String id) async {
    final existingMusicIndex = _items.indexWhere((music) => music.id == id);
    await musicRef.doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    _items.removeAt(existingMusicIndex);
    notifyListeners();
  }
}