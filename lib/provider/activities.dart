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
  UserAccount? currentUser;
  SelectActivity? selectActivity;

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
      QuerySnapshot faveLists = await usersRef.doc(currentUserID).collection('favorites').get();
      final extractedData = faveLists.docs.map((g) => UserAccount.fromDocument(g)).toList();
      if (extractedData == null) {
        return;
      }

      _faveUsers = extractedData;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchSpecificActivity(String currentUserID, String activityID) async{
    try {

      currentUser = UserAccount(id:  FirebaseAuth.instance.currentUser!.uid);
      DocumentSnapshot gameDoc = await usersRef.doc(currentUserID).collection('activities').doc(activityID).get();
      final d = gameDoc.data() as Map;
      Map going = d['going'];

      List<String> userIds = [];
      List<UserAccount> users = [];
      going.forEach((userId, selected) {
        if ((selected && userId != currentUser!.id) || (selected && userId == currentUser!.id)) {
          userIds.add(userId);
        }
      });
      await Future.forEach(userIds, (userId) async {
        DocumentSnapshot userDoc = await usersRef.doc(userId.toString()).get();
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
    currentUser = UserAccount(id: user!.uid);
    selectActivity = SelectActivity(id: activity.id);
    DocumentSnapshot doc = await usersRef.doc(currentUser!.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      usersRef.doc(currentUser!.id).collection('activities').doc(selectActivity!.id).set({
        'id': selectActivity!.id,
        'caption': activity.caption,
        'interestName': activity.interestName,
        'meetUpType': activity.meetUpType,
        'companionType': activity.companionType,
        'participants': activity.participants,
        'scheduleType': activity.scheduleType,
        'scheduleDate': activity.scheduleDate,
        'scheduleTime': activity.scheduleTime,
        'location': activity.location,
        'invitationLink': activity.invitationLink,
        'notes': activity.notes,
        'creatorId': currentUser!.id,
        'creatorName': currentUser!.firstName,
        'creatorPhoto': currentUser!.photoURL,
        'timestamp': timestamp,
        'type': 'invitation',
        'going': {},
      });
      final newActivity = SelectActivity(
        id: selectActivity!.id,
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
    await usersRef.doc(currentUser!.id).collection('activities').doc(id).delete();
    notifyListeners();
  }

  Future<void> deleteFave(String id) async {
    final existingGameIndex = _items.indexWhere((g) => g.id == id);
    await usersRef.doc(currentUser!.id).collection('favorites').doc(id).delete();
    _items.removeAt(existingGameIndex);
    notifyListeners();
  }

}