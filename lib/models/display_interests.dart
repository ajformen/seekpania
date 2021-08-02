import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayInterests with ChangeNotifier{
  final String? id;
  final String? title;
  final String? type;

  DisplayInterests({
    this.id,
    this.title,
    this.type,
  });

  factory DisplayInterests.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return DisplayInterests(
      id: d['id'],
      title: d['title'],
      type: d['type'],
    );
  }
}