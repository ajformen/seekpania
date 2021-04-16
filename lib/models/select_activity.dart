import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/user_account.dart';

class SelectActivity with ChangeNotifier {
  final String? id;
  final String? caption;
  final String? interestName;
  final String? meetUpType;
  final String? companionType;
  final int? participants;
  final String? scheduleDate;
  final String? scheduleTime;
  final String? location;
  final String? invitationLink;
  final String? notes;
  final String? creatorId;
  final String? creatorName;
  final String? creatorPhoto;
  final String? type; // 'invitations', 'messaging', 'reminder' ..
  // final DateTime timestamp;
  final dynamic going;

  SelectActivity({
    this.id,
    this.caption,
    this.interestName,
    this.meetUpType,
    this.companionType,
    this.participants,
    this.scheduleDate,
    this.scheduleTime,
    this.location,
    this.invitationLink,
    this.notes,
    this.creatorId,
    this.creatorName,
    this.creatorPhoto,
    this.type,
    // this.timestamp,
    this.going,
  });

  factory SelectActivity.fromDocument(DocumentSnapshot doc) {
    final d = doc.data();
    return SelectActivity(
      id: d!['id'],
      caption: d['caption'],
      interestName: d['interestName'],
      meetUpType: d['meetUpType'],
      companionType: d['companionType'],
      participants: d['participants'],
      scheduleDate: d['scheduleDate'],
      scheduleTime: d['scheduleTime'],
      location: d['location'],
      invitationLink: d['invitationLink'],
      notes: d['notes'],
      creatorId: d['creatorId'],
      creatorName: d['creatorName'],
      creatorPhoto: d['creatorPhoto'],
      type: d['type'],
      // timestamp: d['timestamp'],
      going: d['going'],
    );
  }

}