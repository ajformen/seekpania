import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/display_interests.dart';
import 'package:challenge_seekpania/models/selections/select_movies.dart';
import 'package:challenge_seekpania/models/user_account.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Movies with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String moviesId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final moviesRef = FirebaseFirestore.instance.collection('movies');
  UserAccount currentUser;
  SelectMovies theMovies;

  List<SelectMovies> _items = [
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

  List<SelectMovies> get items {
    return _items;
  }

  List<DisplayInterests> _moviesItems = [];

  List<DisplayInterests> get moviesItems {
    return _moviesItems;
  }

  // List<DisplayInterests> _userGameItems = [];
  //
  // List<DisplayInterests> get userGameItems {
  //   return _userGameItems;
  // }

  SelectMovies findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchMoviesInterests() async {
    try {
      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot moviesList = await usersRef.doc(currentUser.id).collection('interests').where('type', isEqualTo: 'movies').get();
      final extractedData = moviesList.docs.map((game) => DisplayInterests.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _moviesItems = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetMovies() async {
    try {
      currentUser = UserAccount(id: user.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot snapshot = await moviesRef.orderBy('timestamp').get();
      print('VIEW DATA');
      print(snapshot);
      final extractedData = snapshot.docs.map((doc) => SelectMovies.fromDocument(doc)).toList();
      if (extractedData == null) {
        return;
      }

      _items = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addMovies(SelectMovies movies) async{
    currentUser = UserAccount(id: user.uid);
    theMovies = SelectMovies(id: moviesId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      moviesRef.doc(theMovies.id).set({
        'id': theMovies.id,
        'title': movies.title,
        // 'isSelected': game.isSelected,
        'creatorId': currentUser.id,
        'creator-email': currentUser.email,
        'timestamp': timestamp,
        'selects': {},
      });
      final newMovies = SelectMovies(
        id: theMovies.id,
        title: movies.title,
      );
      _items.add(newMovies);
      // DocumentSnapshot res = await gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).get();
      // res = await gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).get();
      // theGame = SelectGames.fromDocument(res);
      moviesId = Uuid().v4();
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateMovies(String id, SelectMovies newMovies) async {
    final moviesIndex = _items.indexWhere((movies) => movies.id == id);
    print(moviesIndex);
    print('UPDATE MOVIES ID:');
    print(id);
    if (moviesIndex >= 0) {
      await moviesRef.doc(id).update({
        'title': newMovies.title,
      });
      _items[moviesIndex] = newMovies;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteMovies(String id) async {
    final existingMoviesIndex = _items.indexWhere((movies) => movies.id == id);
    await moviesRef.doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    _items.removeAt(existingMoviesIndex);
    notifyListeners();
  }
}