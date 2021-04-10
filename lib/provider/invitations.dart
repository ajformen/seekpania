import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_invite.dart';
import 'package:challenge_seekpania/models/select_activity.dart';

class Invitations with ChangeNotifier {
  DateTime timestamp = DateTime.now();
  String invId = Uuid().v4();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final activityFeedRef = FirebaseFirestore.instance.collection('feeds');
  UserAccount currentUser;
  SelectInvite selectInvite;

  List<SelectInvite> _items = [];

  List<SelectInvite> get items {
    return _items;
  }

  List<SelectInvite> _currentUserInvitations = [];

  List<SelectInvite> get currentUserInvitations {
    return _currentUserInvitations;
  }

  SelectInvite findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  Future<void> fetchUserInvitations(String userId) async {
    try {
      // QuerySnapshot snapshot = await gamesRef.doc(currentUser.id).collection('gamesAdded').where('creatorId', isEqualTo: '$currentUser.id').orderBy('timestamp').get();
      QuerySnapshot feedsList = await activityFeedRef.doc(userId).collection('invitations').orderBy('timestamp', descending: true).limit(50).get();
      final extractedData = feedsList.docs.map((game) => SelectInvite.fromDocument(game)).toList();
      if (extractedData == null) {
        return;
      }

      _currentUserInvitations = extractedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addInvite(SelectActivity activity, String userId) async{
    currentUser = UserAccount(id: user.uid);
    selectInvite = SelectInvite(id: invId);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    try{
      // gamesRef.doc(currentUser.id).collection('gamesAdded').doc(theGame.id).set({
      // usersRef.doc(currentUser.id).collection('activities').doc(userId).collection('invitation').doc(selectInvite.id).set({
      activityFeedRef.doc(userId).collection('invitations').doc(selectInvite.id).set({
        'id': selectInvite.id,
        'activityID': activity.id,
        'interestName': activity.interestName,
        'caption': activity.caption,
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
        'invitationStatus': 'pending',
        'accepts': {},
      });
      final newInvite = SelectInvite(
        id: selectInvite.id,
        caption: activity.caption,
      );
      _items.add(newInvite);
      invId = Uuid().v4();
      selectInvite = SelectInvite(id: invId);
      timestamp = DateTime.now();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteInvite(String currentUserID, String id) async {
    // final existingGameIndex = _items.indexWhere((invite) => invite.id == id);
    await activityFeedRef.doc(currentUserID).collection('invitations').doc(id).delete();
    // _items.removeWhere((game) => game.id == id);
    // _items.removeAt(existingGameIndex);
    notifyListeners();
  }

}