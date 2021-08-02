import 'package:challenge_seekpania/models/selections/select_sports.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// import 'package:seekpania_web/models/selections/select_live_events.dart';

class Sports with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String gameId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final sportsRef = FirebaseFirestore.instance.collection('sports');
  // UserAccount currentUser;
  late SelectSports theSelect;

  List<SelectSports> _items = [];

  List<SelectSports> get items {
    return _items;
  }

  SelectSports findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchAndSetScreen() async {
    try {
      // currentUser = UserAccount(id: user.uid);
      // print('USER IS');
      // print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot snapshot = await sportsRef.orderBy('timestamp').get();
      print('VIEW DATA');
      print(snapshot);
      final extractedData =
      snapshot.docs.map((doc) => SelectSports.fromDocument(doc)).toList();
      if (extractedData == null) {
        return;
      }

      _items = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addEvent(SelectSports game) async {
    // currentUser = UserAccount(id: user.uid);
    theSelect = SelectSports(id: gameId);
    // DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    // currentUser = UserAccount.fromDocument(doc);
    try {
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      sportsRef.doc(theSelect.id).set({
        'id': theSelect.id,
        'title': game.title,
        // 'isSelected': game.isSelected,
        // 'creatorId': currentUser.id,
        // 'creator-email': currentUser.email,
        'timestamp': timestamp,
        'selects': {},
      });
      final newGame = SelectSports(
        id: theSelect.id,
        title: game.title,
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

  Future<void> updateEvent(String id, SelectSports newGame) async {
    final gameIndex = _items.indexWhere((game) => game.id == id);
    print(gameIndex);
    print('UPDATE GAME ID:');
    print(id);
    if (gameIndex >= 0) {
      await sportsRef.doc(id).update({
        'title': newGame.title,
      });
      _items[gameIndex] = newGame;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteEvent(String id) async {
    final existingGameIndex = _items.indexWhere((game) => game.id == id);
    await sportsRef.doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    _items.removeAt(existingGameIndex);
    notifyListeners();
  }
}
