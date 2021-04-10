import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class UserAccount with ChangeNotifier{
  final String id;
  final String email;
  final String photoURL;
  final String firstName;
  final String lastName;
  final String gender;
  final String genderCustom;
  final String status;
  final String city;
  final String country;
  final String countryDialCode;
  final String birthDate;
  final int age;
  final String currentLocation;
  bool isFavorite;
  final dynamic favorites;

  UserAccount({
    this.id,
    this.email,
    this.photoURL,
    this.firstName,
    this.lastName,
    this.gender,
    this.genderCustom,
    this.status,
    this.city,
    this.country,
    this.countryDialCode,
    this.birthDate,
    this.age,
    this.currentLocation,
    this.isFavorite,
    this.favorites,
  });

  factory UserAccount.fromDocument(DocumentSnapshot doc) {
    final d = doc.data();
    return UserAccount(
      id: d['id'],
      email: d['email'],
      photoURL: d['photoUrl'],
      firstName: d['firstName'],
      lastName: d['lastName'],
      gender: d['gender'],
      genderCustom: d['genderCustom'],
      status: d['status'],
      city: d['city'],
      country: d['country'],
      countryDialCode: d['countryDialCode'],
      birthDate: d['birthDate'],
      age: d['age'],
      currentLocation: d['currentLocation'],
      favorites: d['favorites']
    );
  }

  Future<void> toggleFavoriteStatus(UserAccount accountUser) async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user.uid);
    String accountUserID = accountUser.id;
    final usersRef = FirebaseFirestore.instance.collection('users');
    // isFavorite = favorites[userId] == true;
    try {
      await usersRef.doc(currentUser.id).update({
        'favorites.$accountUserID' : true,
      });
      // favorites[userId] = true;
      // await usersRef.doc(currentUser.id).collection('favorites').doc(accountUser.id).set({
      //   'id': accountUser.id,
      //   'firstName': accountUser.firstName,
      //   'type': 'favorite',
      // });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

}