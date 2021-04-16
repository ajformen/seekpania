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
    return DisplayInterests(
      id: doc.data()!['id'],
      title: doc.data()!['title'],
      type: doc.data()!['type'],
    );
  }
}