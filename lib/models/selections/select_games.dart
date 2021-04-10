import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectGames with ChangeNotifier {
  final String id;
  final String title;
  bool isSelected;
  final dynamic selects;

  SelectGames({
    this.id,
    this.title,
    this.isSelected,
    this.selects,
  });

  factory SelectGames.fromDocument(DocumentSnapshot doc) {
    return SelectGames(
      id: doc.data()['id'],
      title: doc.data()['title'],
      // isSelected: doc.data()['isSelected'],
      selects: doc['selects'],
    );
  }

  factory SelectGames.fromDocument2(DocumentSnapshot doc) {
    return SelectGames(
      title: doc.data()['title'],
    );
  }

  Future<void> toggleSelectedStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user.uid);
    String currentUserID = currentUser.id;
    final gamesRef = FirebaseFirestore.instance.collection('games');
    final usersRef = FirebaseFirestore.instance.collection('users');
    // isSelected = !isSelected;
    isSelected = selects[currentUserID] == true;
    try {
      // await gamesRef.doc(currentUser.id).collection('gamesSelected').doc(id).set({
      //   'title': title,
      //   'isSelected': isSelected,
      // });
      // if = true & false; else if = false & true --- IS WORKING FINE EXCEPT THE FIRST TAP THE TOGGLE WONT SELECT BUT VALUE TRUE FALSE IS CORRECT
      if (isSelected) {
        await gamesRef.doc(id).update({
          'selects.$currentUserID': false,
        });
        selects[currentUserID] = false;
        //....
        await usersRef.doc(currentUser.id).collection('interests').doc(id).delete();
      } else if (!isSelected) {
        await gamesRef.doc(id).update({
          'selects.$currentUserID' : true
        });
        selects[currentUserID] = true;
        await usersRef.doc(currentUser.id).collection('interests').doc(id).set({
          'id': id,
          'title': title,
          'type': 'games',
        });
      }

      // 1) Get usersRef
      // 2) Create [interests] > [games]
      // IF (isSelected)
      // 3) usersRef.[interests].[games].set({
      //      game_id: id,
      //      title: title
      // })
      // else if (!IsSelected) {
      //     remove the game nga naa sa [interests].[games]
      // }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

}