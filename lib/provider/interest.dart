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
  final readingRef = FirebaseFirestore.instance.collection('reading');
  final outdoorsRef = FirebaseFirestore.instance.collection('outdoors');
  final sportsRef = FirebaseFirestore.instance.collection('sports');
  String intId = Uuid().v4();
  late Map selects;
  late UserAccount currentUser;
  late DisplayInterests disInterest;

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

  List<UserAccount> _countryInterest = [];
  List<UserAccount> get countryInterest {
    return _countryInterest;
  }

  DisplayInterests findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchCurrentUserInterests(String currentUserID) async {
    try {
      QuerySnapshot gamesList =
          await usersRef.doc(currentUserID).collection('interests').get();
      final extractedData = gamesList.docs
          .map((game) => DisplayInterests.fromDocument(game))
          .toList();
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
      QuerySnapshot gamesList =
          await usersRef.doc(userId).collection('interests').get();
      final extractedData = gamesList.docs
          .map((game) => DisplayInterests.fromDocument(game))
          .toList();
      if (extractedData == null) {
        return;
      }

      _userInterests = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchUsersInterests(
      String interestId, String searchType, String currentLoc) async {
    try {
      currentUser = UserAccount(id: FirebaseAuth.instance.currentUser!.uid);
      if (searchType == 'games') {
        DocumentSnapshot gameDoc = await gamesRef.doc(interestId).get();
        final d = gameDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'liveEvents') {
        DocumentSnapshot eventDoc = await liveEventsRef.doc(interestId).get();
        final d = eventDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'music') {
        DocumentSnapshot musicDoc = await musicRef.doc(interestId).get();
        final d = musicDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'movies') {
        DocumentSnapshot moviesDoc = await moviesRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'reading') {
        DocumentSnapshot moviesDoc = await readingRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'outdoors') {
        DocumentSnapshot moviesDoc = await outdoorsRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'sports') {
        DocumentSnapshot moviesDoc = await sportsRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      }

      List<String> userIds = [];
      List<UserAccount> users = [];
      selects.forEach((userId, selected) {
        if (selected && userId != currentUser.id) {
          userIds.add(userId);
        }
      });
      await Future.forEach(userIds, (userId) async {
        DocumentSnapshot userDoc = await usersRef.doc(userId.toString()).get();
        print('AJ userDoc.data()');
        print(userDoc.data());
        final user = UserAccount.fromDocument(userDoc);
        print('--------------');
        if (user.currentLocation == currentLoc) {
          users.add(user);
        }
      });
      print(users);
      _interestItems = users;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  /// Match Users With Interest And Country
  Future<void> fetchUsersInterestsCountry(
      String interestId, String searchType, String country) async {
    try {
      currentUser = UserAccount(id: FirebaseAuth.instance.currentUser!.uid);
      if (searchType == 'games') {
        DocumentSnapshot gameDoc = await gamesRef.doc(interestId).get();
        final d = gameDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'liveEvents') {
        DocumentSnapshot eventDoc = await liveEventsRef.doc(interestId).get();
        final d = eventDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'music') {
        DocumentSnapshot musicDoc = await musicRef.doc(interestId).get();
        final d = musicDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'movies') {
        DocumentSnapshot moviesDoc = await moviesRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'reading') {
        DocumentSnapshot moviesDoc = await readingRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'outdoors') {
        DocumentSnapshot moviesDoc = await outdoorsRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      } else if (searchType == 'sports') {
        DocumentSnapshot moviesDoc = await sportsRef.doc(interestId).get();
        final d = moviesDoc.data() as Map;
        selects = d['selects'];
      }
      print('COUNTRY');
      print(country);

      List<String> userIds = [];
      List<UserAccount> users = [];
      selects.forEach((userId, selected) {
        if (selected && userId != currentUser.id) {
          userIds.add(userId);
        }
      });
      await Future.forEach(userIds, (userId) async {
        DocumentSnapshot userDoc = await usersRef.doc(userId.toString()).get();
        print(userDoc.data());
        final user = UserAccount.fromDocument(userDoc);
        print('--------------');
        if (user.country == country) {
          users.add(user);
        }
      });
      print(users);
      _countryInterest = users;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
