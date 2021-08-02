import 'package:challenge_seekpania/models/selections/select_reading.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// import 'package:seekpania_web/models/selections/select_live_events.dart';

class Readings with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String gameId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final readingRef = FirebaseFirestore.instance.collection('reading');
  // UserAccount currentUser;
  late SelectReading theSelect;

  List<SelectReading> _items = [];

  List<SelectReading> get items {
    return _items;
  }

  SelectReading findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchAndSetScreen() async {
    try {
      // currentUser = UserAccount(id: user.uid);
      // print('USER IS');
      // print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot snapshot = await readingRef.orderBy('timestamp').get();
      print('VIEW DATA');
      print(snapshot);
      final extractedData =
      snapshot.docs.map((doc) => SelectReading.fromDocument(doc)).toList();
      if (extractedData == null) {
        return;
      }

      _items = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addEvent(SelectReading game) async {
    // currentUser = UserAccount(id: user.uid);
    theSelect = SelectReading(id: gameId);
    // DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    // currentUser = UserAccount.fromDocument(doc);
    try {
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      readingRef.doc(theSelect.id).set({
        'id': theSelect.id,
        'title': game.title,
        // 'isSelected': game.isSelected,
        // 'creatorId': currentUser.id,
        // 'creator-email': currentUser.email,
        'timestamp': timestamp,
        'selects': {},
      });
      final newGame = SelectReading(
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

  Future<void> updateEvent(String id, SelectReading newGame) async {
    final gameIndex = _items.indexWhere((game) => game.id == id);
    print(gameIndex);
    print('UPDATE GAME ID:');
    print(id);
    if (gameIndex >= 0) {
      await readingRef.doc(id).update({
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
    await readingRef.doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    _items.removeAt(existingGameIndex);
    notifyListeners();
  }
}
