import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/user_account.dart';

class SelectOutdoors with ChangeNotifier {
  final String? id;
  final String? title;
  bool? isSelected;
  final dynamic selects;

  SelectOutdoors({
    this.id,
    this.title,
    this.isSelected,
    this.selects,
  });

  factory SelectOutdoors.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return SelectOutdoors(
      id: d['id'],
      title: d['title'],
      selects: doc['selects'],
    );
  }

  Future<void> toggleSelectedStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    String currentUserID = currentUser.id!;
    final outdoorsRef = FirebaseFirestore.instance.collection('outdoors');
    final usersRef = FirebaseFirestore.instance.collection('users');
    isSelected = selects[currentUserID] == true;
    try {
      if (isSelected!) {
        await outdoorsRef.doc(id).update({
          'selects.$currentUserID': false,
        });
        selects[currentUserID] = false;
        //....
        await usersRef.doc(currentUser.id).collection('interests').doc(id).delete();
      } else if (!isSelected!) {
        await outdoorsRef.doc(id).update({
          'selects.$currentUserID' : true
        });
        selects[currentUserID] = true;
        await usersRef.doc(currentUser.id).collection('interests').doc(id).set({
          'id': id,
          'title': title,
          'type': 'outdoors',
        });
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
