import 'package:challenge_seekpania/models/display_interests.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/selections/select_live_event.dart';
import 'package:challenge_seekpania/models/user_account.dart';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiveEvents with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  String eventId = Uuid().v4();
  final usersRef = FirebaseFirestore.instance.collection('users');
  final liveEventsRef = FirebaseFirestore.instance.collection('liveEvents');
  UserAccount currentUser;
  SelectLiveEvent theEvent;
  DisplayInterests disInterests;

  List<SelectLiveEvent> _items = [
    // SelectLiveEvent(
    //   id: 'liveevent1',
    //   title: 'Ballet',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent2',
    //   title: 'Bars',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent3',
    //   title: 'Concerts',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent4',
    //   title: 'Dance Halls',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent5',
    //   title: 'Music festivals',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent6',
    //   title: 'Nightclubs',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent7',
    //   title: 'Parties',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent8',
    //   title: 'Plays',
    // ),
    // SelectLiveEvent(
    //   id: 'liveevent9',
    //   title: 'Theatre',
    // ),
  ];

  List<SelectLiveEvent> get items {
    return _items;
  }

  List<DisplayInterests> _eventItems = [];

  List<DisplayInterests> get eventItems {
    return _eventItems;
  }

  SelectLiveEvent findById(String id) {
    return _items.firstWhere((livent) => livent.id == id);
  }

  Future<void> fetchLiveEventInterests() async {
    try {
      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot gamesList = await usersRef.doc(currentUser.id).collection('interests').where('type', isEqualTo: 'liveEvents').get();
      final extractedData = gamesList.docs.map((game) => DisplayInterests.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _eventItems = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetLiveEvents() async {
    try {
      currentUser = UserAccount(id: user.uid);
      print('USER IS');
      print(currentUser.id);
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot snapshot = await liveEventsRef.orderBy('timestamp').get();
      print('VIEW DATA');
      print(snapshot);
      final extractedData = snapshot.docs.map((doc) => SelectLiveEvent.fromDocument(doc)).toList();
      if (extractedData == null) {
        return;
      }

      _items = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addLiveEvent(SelectLiveEvent event) async{
    currentUser = UserAccount(id: user.uid);
    theEvent = SelectLiveEvent(id: eventId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try {
      liveEventsRef.doc(theEvent.id).set({
        'id': theEvent.id,
        'title': event.title,
        // 'isSelected': game.isSelected,
        'creatorId': currentUser.id,
        'creator-email': currentUser.email,
        'timestamp': timestamp,
        'selects': {},
      });
      final newEvent = SelectLiveEvent(
        id: theEvent.id,
        title: event.title,
      );
      _items.add(newEvent);
      eventId = Uuid().v4();
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateLiveEvent(String id, SelectLiveEvent newEvent) async {
    final eventIndex = _items.indexWhere((event) => event.id == id);
    print(eventIndex);
    print('UPDATE EVENT ID:');
    print(id);
    if (eventIndex >= 0) {
      await liveEventsRef.doc(id).update({
        'title': newEvent.title,
      });
      _items[eventIndex] = newEvent;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteLiveEvent(String id) async {
    final existingEventIndex = _items.indexWhere((event) => event.id == id);
    await liveEventsRef.doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    _items.removeAt(existingEventIndex);
    notifyListeners();
  }

}
