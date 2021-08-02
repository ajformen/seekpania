import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';

class SelectEmergency with ChangeNotifier {
  final String? id;
  final String? name;
  final String? relationship;
  final String? email;

  SelectEmergency({
    this.id,
    this.name,
    this.relationship,
    this.email,
  });

  factory SelectEmergency.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return SelectEmergency(
      id: d['id'],
      name: d['name'],
      relationship: d['relationship'],
      email: d['email'],
    );
  }
}