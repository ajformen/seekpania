import 'package:challenge_seekpania/widget/points/points_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:challenge_seekpania/widget/check_user.dart';
import 'package:challenge_seekpania/widget/profile.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/page/home_page.dart';
import 'package:challenge_seekpania/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:challenge_seekpania/widget/admin/manage_screen.dart';
import 'package:challenge_seekpania/widget/home/activity/my_activity.dart';
import 'package:challenge_seekpania/widget/favorites/favorites.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
late UserAccount currentUser;

class Account extends StatefulWidget {
  final String? accountID;

  Account({ this.accountID });

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // final String currentUserID = currentUser?.id;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    setState(() {

    });
    print('WIDGET ACCOUNT ID: ');
    print(widget.accountID);
  }

  // DO NOT DELETE THIS, THIS IS CRUCIAL!
  void dispose() {
    super.dispose();
    print('DISPOSE ACCOUNT');
  }

  clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  logout() async {
    print('SIGN OUT NA');
    await googleSignIn.signOut();
    // FirebaseAuth.instance.signOut();

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    showFlash(
        context: context,
        duration: const Duration(seconds: 4),
        builder: (context, controller) {
          return Flash.bar(
            controller: controller,
            // backgroundGradient: LinearGradient(
            //   colors: [Colors.indigo, Colors.deepPurple],
            // ),
            backgroundColor: Colors.grey[850]!,
            child: FlashBar(
              message: Text('Logout successful',
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
          );
        }
    );
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());

  manage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ManageScreen()
        )
    );
  }

  points() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PointsScreen()
        )
    );
  }

  myActivity() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyActivity()
        )
    );
  }

  myFavorites() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Favorites()
        )
    );
  }

  viewProfile() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Profile(profileID: currentUser.id!,)));
  }

  // buildAccount() {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
          future: usersRef.doc(widget.accountID).get(),
          // future: usersRef.doc(user.uid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return buildLoading();
            }
            currentUser = UserAccount.fromDocument(snapshot.data!);
            return ListView(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              maxRadius: 45,
                              backgroundImage: NetworkImage(user!.photoURL!),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentUser.firstName!,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: viewProfile,
                                    child: Container(
                                      height: 30.0,
                                      // decoration: BoxDecoration(
                                      //   color: Colors.indigo,
                                      //   borderRadius: BorderRadius.circular(7.0),
                                      // ),
                                      child: Text(
                                        "View Profile",
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ListTile(
                          leading: Icon(Icons.circle, color: Colors.deepPurple),
                          title: Text('Points', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {points();},
                        ),
                        Divider(color: Color(0xff9933ff)),
                        ListTile(
                          leading: Icon(Icons.list, color: Colors.deepPurple),
                          title: Text('My Activity', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {myActivity();},
                        ),
                        Divider(color: Color(0xff9933ff)),
                        ListTile(
                          leading: Icon(Icons.favorite, color: Colors.deepPurple),
                          title: Text('Fave Companions', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {myFavorites();},
                        ),
                        Divider(color: Color(0xff9933ff)),
                        ListTile(
                          leading: Icon(Icons.payment, color: Colors.deepPurple),
                          title: Text('Subscription Package', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {},
                        ),
                        Divider(color: Color(0xff9933ff)),
                        ListTile(
                          leading: Icon(Icons.person_add, color: Colors.deepPurple),
                          title: Text('Safety Contact', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {},
                        ),
                        Divider(color: Color(0xff9933ff)),
                        ListTile(
                          leading: Icon(Icons.settings, color: Colors.deepPurple),
                          title: Text('Settings', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {},
                        ),
                        Divider(color: Color(0xff9933ff)),
                        ListTile(
                          leading: Icon(Icons.build, color: Colors.deepPurple),
                          title: Text('Manage', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {manage();},
                        ),
                        Divider(color: Color(0xff9933ff)),
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.deepPurple),
                          title: Text('Logout', style: TextStyle(color: Colors.grey[800]),),
                          onTap: () {logout();},
                        ),
                        // Divider(color: Color(0xff9933ff)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
    );
  }
}
