import 'package:cloud_firestore/cloud_firestore.dart';

class InterestAccount {
  final String? id;
  final String? title;
  final bool? isSelected;

  InterestAccount({
    this.id,
    this.title,
    this.isSelected,
  });

  factory InterestAccount.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return InterestAccount(
      id: d['id'],
      title: d['title'],
      isSelected: d['isSelected'],
    );
  }
}