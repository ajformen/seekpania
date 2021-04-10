import 'package:cloud_firestore/cloud_firestore.dart';

class InterestAccount {
  final String id;
  final String title;
  final bool isSelected;

  InterestAccount({
    this.id,
    this.title,
    this.isSelected,
  });

  factory InterestAccount.fromDocument(DocumentSnapshot doc) {
    return InterestAccount(
      id: doc.data()['id'],
      title: doc.data()['title'],
      isSelected: doc.data()['isSelected'],
    );
  }
}