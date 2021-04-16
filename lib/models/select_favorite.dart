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
    return SelectFavorite(
      id: doc.data()!['id'],
      favorites: doc['favorites'],
      isFavorite: false,
    );
  }

  Future<void> toggleFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    String currentUserID = currentUser.id!;
    // final gamesRef = FirebaseFirestore.instance.collection('games');
    final usersRef = FirebaseFirestore.instance.collection('users');
    isFavorite = favorites[currentUserID] == true;
    try {
      // await gamesRef.doc(currentUser.id).collection('gamesSelected').doc(id).set({
      //   'title': title,
      //   'isSelected': isSelected,
      // });
      // if = true & false; else if = false & true --- IS WORKING FINE EXCEPT THE FIRST TAP THE TOGGLE WONT SELECT BUT VALUE TRUE FALSE IS CORRECT
      if (isFavorite!) {
        await usersRef.doc(id).update({
          'favorites.$currentUserID': false,
        });
        favorites[currentUserID] = false;
        //....
        // await usersRef.doc(currentUser.id).collection('interests').doc(id).delete();
      } else if (!isFavorite!) {
        await usersRef.doc(id).update({
          'favorites.$currentUserID' : true
        });
        favorites[currentUserID] = true;
        // await usersRef.doc(currentUser.id).collection('interests').doc(id).set({
        //   'id': id,
        //   'type': 'favorite',
        // });
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

}