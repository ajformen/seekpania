import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';

class UserAccount with ChangeNotifier{
  final String? id;
  final String? email;
  final String? photoURL;
  final String? firstName;
  final String? lastName;
  final int? pin;
  final String? gender;
  final String? genderCustom;
  final String? status;
  final String? city;
  final String? country;
  final String? countryDialCode;
  final String? birthDate;
  final int? age;
  final String? userStatus;
  final String? currentLocation;
  final double? points;
  final String? health;
  bool? isFavorite;
  final dynamic favorites;
  final dynamic chats;

  UserAccount({
    this.id,
    this.email,
    this.photoURL,
    this.firstName,
    this.lastName,
    this.pin,
    this.gender,
    this.genderCustom,
    this.status,
    this.city,
    this.country,
    this.countryDialCode,
    this.birthDate,
    this.age,
    this.userStatus,
    this.currentLocation,
    this.points,
    this.health,
    this.isFavorite,
    this.favorites,
    this.chats,
  });

  factory UserAccount.fromDocument(DocumentSnapshot doc) {
    final d = doc.data() as Map;
    return UserAccount(
      id: d['id'],
      email: d['email'],
      photoURL: d['photoURL'],
      firstName: d['firstName'],
      lastName: d['lastName'],
      pin: d['pin'],
      gender: d['gender'],
      genderCustom: d['genderCustom'],
      status: d['status'],
      city: d['city'],
      country: d['country'],
      countryDialCode: d['countryDialCode'],
      birthDate: d['birthDate'],
      age: d['age'],
      userStatus: d['userStatus'],
      currentLocation: d['currentLocation'],
      points: d['points'],
      health: d['health'],
      favorites: d['favorites'],
      chats: d['chats'],
    );
  }

  Future<void> toggleFavoriteStatus(UserAccount accountUser) async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    String accountUserID = accountUser.id!;
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      await usersRef.doc(currentUser.id).update({
        'favorites.$accountUserID' : true,
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> toggleFavoriteStatus2(UserAccount accountUser) async {
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    String accountUserID = accountUser.id!;
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      // alternative fave route
      await usersRef.doc(currentUser.id).collection('favorites').doc(accountUserID).set({
        'id': accountUserID,
        'firstName': accountUser.firstName,
        'photoURL': accountUser.photoURL,
        'type': 'favorite',
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deactivateAccount(String userId) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    try {
      await usersRef.doc(userId).update({
        'userStatus': 'Deactivated',
      });

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> activateAccount(String userId) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    try {
      await usersRef.doc(userId).update({
        'userStatus': 'Active',
      });

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteAccount(String userId, String name, String photoURL) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final usersDbRef = FirebaseFirestore.instance.collection('usersDB');
    final deleteAccRef = FirebaseFirestore.instance.collection('deleted accounts');

    try {
      await usersRef.doc(userId).update({
        'userStatus': 'Deleted',
      });
      await usersDbRef.doc(userId).update({
        'userStatus': 'Deleted',
      });
      await usersRef.doc(userId).delete();
      await deleteAccRef.doc(userId).set({
        'id': userId,
        'firstName': name,
        'photoURL': photoURL,
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> checkHealth(String userId) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    try {
      await usersRef.doc(userId).update({
        'health': 'NOT SAFE',
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

}