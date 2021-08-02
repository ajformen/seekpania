import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SelectActivity with ChangeNotifier {
  final String? id;
  final String? caption;
  final String? interestName;
  final String? meetUpType;
  final String? companionType;
  final int? participants;
  final String? scheduleType;
  final String? scheduleDate;
  final String? scheduleTime;
  final String? location;
  final String? invitationLink;
  final String? notes;
  final String? creatorId;
  final String? creatorName;
  final String? creatorPhoto;
  final String? type;
  final dynamic going;

  SelectActivity({
    this.id,
    this.caption,
    this.interestName,
    this.meetUpType,
    this.companionType,
    this.participants,
    this.scheduleType,
    this.scheduleDate,
    this.scheduleTime,
    this.location,
    this.invitationLink,
    this.notes,
    this.creatorId,
    this.creatorName,
    this.creatorPhoto,
    this.type,
    this.going,
  });

  factory SelectActivity.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return SelectActivity(
      id: d['id'],
      caption: d['caption'],
      interestName: d['interestName'],
      meetUpType: d['meetUpType'],
      companionType: d['companionType'],
      participants: d['participants'],
      scheduleType: d['scheduleType'],
      scheduleDate: d['scheduleDate'],
      scheduleTime: d['scheduleTime'],
      location: d['location'],
      invitationLink: d['invitationLink'],
      notes: d['notes'],
      creatorId: d['creatorId'],
      creatorName: d['creatorName'],
      creatorPhoto: d['creatorPhoto'],
      type: d['type'],
      going: d['going'],
    );
  }

}