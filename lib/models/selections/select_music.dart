import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectMusic with ChangeNotifier {
  final String? id;
  final String? title;
  bool? isSelected;
  final dynamic selects;

  SelectMusic({
    this.id,
    this.title,
    this.isSelected,
    this.selects,
  });

  factory SelectMusic.fromDocument(DocumentSnapshot doc) {
    return SelectMusic(
      id: doc.data()!['id'],
      title: doc.data()!['title'],
      // isSelected: doc.data()['isSelected'],
      selects: doc['selects'],
    );
  }

  Future<void> toggleSelectedStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    String currentUserID = currentUser.id!;
    final musicRef = FirebaseFirestore.instance.collection('music');
    final usersRef = FirebaseFirestore.instance.collection('users');
    // isSelected = !isSelected;
    isSelected = selects[currentUserID] == true;
    try {
      if (isSelected!) {
        await musicRef.doc(id).update({
          'selects.$currentUserID': false,
        });
        selects[currentUserID] = false;
        //....
        await usersRef.doc(currentUser.id).collection('interests').doc(id).delete();
      } else if (!isSelected!) {
        await musicRef.doc(id).update({
          'selects.$currentUserID' : true
        });
        selects[currentUserID] = true;
        await usersRef.doc(currentUser.id).collection('interests').doc(id).set({
          'id': id,
          'title': title,
          'type': 'music',
        });
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

}