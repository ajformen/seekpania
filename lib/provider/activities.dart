import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_activity.dart';

class Activities with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String actID = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final activityFeedRef = FirebaseFirestore.instance.collection('feeds');
  UserAccount currentUser;
  SelectActivity selectActivity;

  List<SelectActivity> _items = [];

  List<SelectActivity> get items {
    return _items;
  }

  List<SelectActivity> _currentUserActivity = [];

  List<SelectActivity> get currentUserActivity {
    return _currentUserActivity;
  }

  List<UserAccount> _specificActivity = [];

  List<UserAccount> get specificActivity {
    return _specificActivity;
  }

  List<UserAccount> _faveUsers = [];

  List<UserAccount> get faveUsers {
    return _faveUsers;
  }

  SelectActivity findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchFaveUsers(String currentUserID) async{
    try {
      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
      DocumentSnapshot faveLists = await usersRef.doc(currentUserID).get();
      Map favorites = faveLists.data()['favorites'] as Map;

      List<String> userIds = [];
      List<UserAccount> users = [];
      favorites.forEach((userId, selected) {
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
      _faveUsers = users;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchSpecificActivity(String currentUserID, String activityID) async{
    try {

      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser.uid);
      DocumentSnapshot gameDoc = await usersRef.doc(currentUserID).collection('activities').doc(activityID).get();
      Map going = gameDoc.data()['going'] as Map;

      List<String> userIds = [];
      List<UserAccount> users = [];
      going.forEach((userId, selected) {
        // if (selected && userId != currentUser.id) {
        //   userIds.add(userId);
        // }
        // this one is not working
        if ((selected && userId != currentUser.id) || (selected && userId == currentUser.id)) {
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
      _specificActivity = users;

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchCurrentUserActivity(String currentUserID) async {
    try {
      QuerySnapshot gamesList = await usersRef.doc(currentUserID).collection('activities').get();
      final extractedData = gamesList.docs.map((game) => SelectActivity.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _currentUserActivity = extractedData;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createActivity(SelectActivity activity) async{
    currentUser = UserAccount(id: user.uid);
    selectActivity = SelectActivity(id: activity.id);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      // usersRef.doc(currentUser.id).collection('activities').doc(userId).collection('invitation').doc(selectInvite.id).set({
      usersRef.doc(currentUser.id).collection('activities').doc(selectActivity.id).set({
        'id': selectActivity.id,
        'caption': activity.caption,
        'interestName': activity.interestName,
        'meetUpType': activity.meetUpType,
        'companionType': activity.companionType,
        'participants': activity.participants,
        'scheduleDate': activity.scheduleDate,
        'scheduleTime': activity.scheduleTime,
        'location': activity.location,
        'invitationLink': activity.invitationLink,
        'notes': activity.notes,
        'creatorId': currentUser.id,
        'creatorName': currentUser.firstName,
        'creatorPhoto': currentUser.photoURL,
        'timestamp': timestamp,
        'type': 'invitation',
        // 'invitation_status': 'pending',
        'going': {},
      });
      final newActivity = SelectActivity(
        id: selectActivity.id,
        caption: activity.caption,
      );
      _items.add(newActivity);
      actID = Uuid().v4();
      selectActivity = SelectActivity(id: activity.id);
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteActivity(String id) async {
    // final existingGameIndex = _items.indexWhere((invite) => invite.id == id);
    await usersRef.doc(currentUser.id).collection('activities').doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    // _items.removeAt(existingGameIndex);
    notifyListeners();
  }

}