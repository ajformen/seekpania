import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/display_interests.dart';

class Interest with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final gamesRef = FirebaseFirestore.instance.collection('games');
  final liveEventsRef = FirebaseFirestore.instance.collection('liveEvents');
  final musicRef = FirebaseFirestore.instance.collection('music');
  final moviesRef = FirebaseFirestore.instance.collection('movies');
  String intId = Uuid().v4();
  Map selects;
  UserAccount currentUser;
  DisplayInterests disInterest;

  List<DisplayInterests> _items = [];

  List<DisplayInterests> get items {
    return _items;
  }

  List<UserAccount> _interestItems = [];

  List<UserAccount> get interestItems {
    return _interestItems;
  }

  List<DisplayInterests> _currentUserInterests = [];

  List<DisplayInterests> get currentUserInterests {
    return _currentUserInterests;
  }

  List<DisplayInterests> _userInterests = [];

  List<DisplayInterests> get userInterests {
    return _userInterests;
  }

  DisplayInterests findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchCurrentUserInterests(String currentUserID) async {
    try {
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot gamesList = await usersRef.doc(currentUserID).collection('interests').get();
      final extractedData = gamesList.docs.map((game) => DisplayInterests.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _currentUserInterests = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAllInterests(String userId) async {
    try {
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot gamesList = await usersRef.doc(userId).collection('interests').get();
      final extractedData = gamesList.docs.map((game) => DisplayInterests.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _userInterests = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchUsersInterests(String interestId, String searchType) async {
    try {
      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
      // QuerySnapshot searchUsersList = await gamesRef.where('id', isEqualTo: '$interestId').where('selects', isEqualTo: 'true').get();
      // QuerySnapshot searchInterestType = await usersRef.doc(currentUser.id).collection('interests').where('id', isEqualTo: interestId).get();
      if (searchType == 'games') {
        DocumentSnapshot gameDoc = await gamesRef.doc(interestId).get();
        selects = gameDoc.data()['selects'] as Map;
      } else if (searchType == 'liveEvents') {
        DocumentSnapshot eventDoc = await liveEventsRef.doc(interestId).get();
        selects = eventDoc.data()['selects'] as Map;
      } else if (searchType == 'music') {
        DocumentSnapshot musicDoc = await musicRef.doc(interestId).get();
        selects = musicDoc.data()['selects'] as Map;
      } else if (searchType == 'movies') {
        DocumentSnapshot moviesDoc = await moviesRef.doc(interestId).get();
        selects = moviesDoc.data()['selects'] as Map;
      }
      // DocumentSnapshot gameDoc = await gamesRef.doc(interestId).get();
      // Map selects = gameDoc.data()['selects'] as Map;

      List<String> userIds = [];
      List<UserAccount> users = [];
      selects.forEach((userId, selected) {
        if (selected && userId != currentUser.id) {
          userIds.add(userId);
        }
      });
      await Future.forEach(userIds, (userId) async {
        DocumentSnapshot userDoc = await usersRef.doc(userId).get();
        print(userDoc.data());
        final user = UserAccount.fromDocument(userDoc);
        print('--------------');
        print(user.photoURL);
        users.add(user);
      });
      print(users);
      _interestItems = users;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

}