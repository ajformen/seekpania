import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/user_account.dart';

class SelectInvite with ChangeNotifier {
  final String? id;
  final String? activityID;
  final String? interestName;
  final String? caption;
  final String? meetUpType;
  final String? companionType;
  final int? participants;
  final String? scheduleType;
  final String? scheduleDate;
  final String? scheduleTime;
  final String? location;
  final String? notes;
  final String? creatorId;
  final String? creatorName;
  final String? creatorPhoto;
  final String? type;
  final String? invitationStatus;
  final dynamic accepts;
  bool? isAccepted;

  SelectInvite({
    this.id,
    this.activityID,
    this.interestName,
    this.caption,
    this.meetUpType,
    this.companionType,
    this.participants,
    this.scheduleType,
    this.scheduleDate,
    this.scheduleTime,
    this.location,
    this.notes,
    this.creatorId,
    this.creatorName,
    this.creatorPhoto,
    this.type,
    this.invitationStatus,
    this.accepts,
    this.isAccepted,
  });

  factory SelectInvite.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return SelectInvite(
      id: d['id'],
      activityID: d['activityID'],
      interestName: d['interestName'],
      caption: d['caption'],
      meetUpType: d['meetUpType'],
      companionType: d['companionType'],
      participants: d['participants'],
      scheduleType: d['scheduleType'],
      scheduleDate: d['scheduleDate'],
      scheduleTime: d['scheduleTime'],
      location: d['location'],
      notes: d['notes'],
      creatorId: d['creatorId'],
      creatorName: d['creatorName'],
      creatorPhoto: d['creatorPhoto'],
      type: d['type'],
      invitationStatus: d['invitationStatus'],
      accepts: d['accepts'],
    );
  }

  Future<void> pressAccepted(SelectInvite invite, invitationId, userId) async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    final usersRef = FirebaseFirestore.instance.collection('users');
    final activityFeedRef = FirebaseFirestore.instance.collection('feeds');
    print(invite.creatorId);
    print(invitationId);
    print(invite.activityID);
    print(userId);
    print('---------------');

    try {
      await activityFeedRef.doc(userId).collection('invitations').doc(invitationId).update({
        'accepts.$userId' : true,
        'invitationStatus': 'accepted',
      });
      await usersRef.doc(invite.creatorId).collection('activities').doc(invite.activityID).update({
        'going.$userId' : true
      });

      print(invite.caption);
      print(invite.meetUpType);
      print(invite.companionType);
      print(invite.participants);
      print(invite.scheduleType);
      print(invite.scheduleDate);
      print(invite.scheduleTime);
      print(invite.location);
      print(invite.notes);
      print(invite.creatorName);
      print(invite.creatorPhoto);
      print(invite.type);

      SelectInvite selectInvite = SelectInvite(id: invite.activityID);
      await usersRef.doc(userId).collection('activities').doc(selectInvite.id).set({
        'id': invite.activityID,
        'caption': invite.caption,
        'meetUpType': invite.meetUpType,
        'companionType': invite.companionType,
        'participants': invite.participants,
        'scheduleType': invite.scheduleType,
        'scheduleDate': invite.scheduleDate,
        'scheduleTime': invite.scheduleTime,
        'location': invite.location,
        'notes': invite.notes,
        'creatorId': invite.creatorId,
        'creatorName': invite.creatorName,
        'creatorPhoto': invite.creatorPhoto,
        'type': invite.type,
        'going': {
          '$userId' : true
        },
      });

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> pressDeclined(invitationId, userId) async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    final activityFeedRef = FirebaseFirestore.instance.collection('feeds');

    try {
      await activityFeedRef.doc(userId).collection('invitations').doc(invitationId).update({
        'invitationStatus': 'declined',
      });

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

}