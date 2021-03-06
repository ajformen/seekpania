import 'dart:async';
import 'package:challenge_seekpania/widget/select_interest_overview.dart';
import 'package:challenge_seekpania/widget/edit_profile.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/page/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:challenge_seekpania/widget/interest_box.dart';

import 'package:challenge_seekpania/provider/interest.dart';

import 'check_user.dart';


class Profile extends StatefulWidget {
  final String? profileID;

  Profile({this.profileID});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int id = 0;
  int? age;
  DateTime currentYear = DateTime.now();
  DateTime? formatBirthDate;
  String? dateOfBirth;
  String? gender;
  UserAccount? currentUser;

  final user = FirebaseAuth.instance.currentUser;

  void refreshData() {
    id++;
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {

    });
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());

  editInterest() {
    Navigator.of(context).pushNamed(SelectInterestOverview.routeName).then(onGoBack);
  }

  Future<void> _refreshInterests() async {
    await Provider.of<Interest>(context, listen: false).fetchCurrentUserInterests(user!.uid);
  }

  interest() {
    return FutureBuilder(
      future: _refreshInterests(),
      builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
          ? buildLoading()
          : viewInterest(),
    );
  }

  noInterests() {
    return Center(
      child: Text(
        'You don\'t have any selected interests.',
        style: TextStyle(
          fontSize: 12,
          color: Colors.red[600],
        ),
      ),
    );
  }

  viewInterest() {
    final interests = Provider.of<Interest>(context, listen: false).currentUserInterests.map((g) => InterestBox(g.title!)).toList();

    return interests.length == 0 ? noInterests() : Wrap(
      spacing: 8,
      runSpacing: 8,
      direction: Axis.horizontal,
      children: interests,
    );
  }

  editProfile() {
    bool isProfileOwner = currentUser!.id == widget.profileID;
    if (isProfileOwner) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditProfile(currentUserID: currentUser?.id,
                      theCountry: currentUser?.countryDialCode,
                      thePhoto: user!.photoURL)
          )
      ).then(onGoBack);
    }
  }

  buildProfileHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profileID).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoading();
        }
        currentUser = UserAccount.fromDocument(snapshot.data!);
        if (currentUser!.gender == 'Non-Binary') {
          gender = currentUser!.genderCustom;
        } else {
          gender = currentUser!.gender;
        }
        return Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          currentUser!.firstName!,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              currentUser!.age.toString(),
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              ', ',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              '$gender',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              ', ',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              currentUser!.status!,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              currentUser!.city!,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            maxRadius: 55,
                            backgroundImage: NetworkImage(user!.photoURL!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Interests',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 17.0),
                      child: GestureDetector(
                        onTap: editInterest,
                        child: Container(
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                interest(),
                // viewInterest(),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'More about me',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 17.0),
                      child: GestureDetector(
                        onTap: editProfile,
                        child: Container(
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  currentUser!.country!,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Currently living in',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  currentUser!.city!,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'I am',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  currentUser!.status!,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '$gender',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Birthday',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  // dateOfBirth.toString(),
                  currentUser!.birthDate!,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  currentUser!.email!,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[buildProfileHeader()],
      )
    );
  }
}
