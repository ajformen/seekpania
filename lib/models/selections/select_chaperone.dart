import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';

class SelectChaperone with ChangeNotifier {
  final String? id;
  final String? name;
  final String? relationship;

  SelectChaperone({
    this.id,
    this.name,
    this.relationship,
  });

  factory SelectChaperone.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return SelectChaperone(
      id: d['id'],
      name: d['name'],
      relationship: d['relationship'],
    );
  }
}