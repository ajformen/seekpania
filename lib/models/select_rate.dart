import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SelectRate with ChangeNotifier {
  final String? id;
  final int? rate;
  final String? feedback;

  SelectRate({
    this.id,
    this.rate,
    this.feedback,
  });

  factory SelectRate.fromDocument(DocumentSnapshot doc) {
    final d = doc.data();
    return SelectRate(
      id: d!['id'],
      rate: d['rate'],
      feedback: d['feedback'],
    );
  }

}