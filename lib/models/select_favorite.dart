import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectFavorite with ChangeNotifier {
  final String? id;
  bool? isFavorite;
  final dynamic favorites;

  SelectFavorite({
    this.id,
    this.isFavorite,
    this.favorites,
  });

  factory SelectFavorite.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return SelectFavorite(
      id: d['id'],
      favorites: d['favorites'],
      isFavorite: false,
    );
  }

  Future<void> toggleFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    String currentUserID = currentUser.id!;
    final usersRef = FirebaseFirestore.instance.collection('users');
    isFavorite = favorites[currentUserID] == true;
    try {
      if (isFavorite!) {
        await usersRef.doc(id).update({
          'favorites.$currentUserID': false,
        });
        favorites[currentUserID] = false;
        //....
      } else if (!isFavorite!) {
        await usersRef.doc(id).update({
          'favorites.$currentUserID' : true
        });
        favorites[currentUserID] = true;
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

}