import 'package:flash/flash.dart';
import 'package:challenge_seekpania/widget/timeline.dart';
import 'package:challenge_seekpania/widget/account.dart';
import 'package:challenge_seekpania/page/home_page.dart';
import 'package:challenge_seekpania/widget/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/widget/create_account.dart';
import 'package:challenge_seekpania/widget/logged_in_widget.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:challenge_seekpania/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

// final GoogleSignIn googleSignIn = GoogleSignIn();
// final user = FirebaseAuth.instance.currentUser;
final usersRef = FirebaseFirestore.instance.collection('users');
// final DateTime timestamp = DateTime.now();
// UserAccount currentUser;

class CheckUser extends StatefulWidget {
  // final String checkUserID;
  //
  // CheckUser({ this.checkUserID });

  @override
  _CheckUserState createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  @override
  void initState() {
    super.initState();
    setState(() {

    });
    // print('CHECK USER ID: ');
    // print(widget.checkUserID);
    createUserInFirestore();
    // logout();
  }

  @override
  void dispose() {
    super.dispose();
    print('DISPOSE CHECK USER');
  }

  // logout() async {
  //   print('SIGN OUT NA');
  //   await googleSignIn.signOut();
  //   FirebaseAuth.instance.signOut();
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  // }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    // final GoogleSignInAccount user = googleSignIn.currentUser;
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.uid).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoggedInWidget()));
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
      showFlash(
          context: context,
          duration: const Duration(seconds: 1),
          builder: (context, controller) {
            return Flash.bar(
              controller: controller,
              // backgroundGradient: LinearGradient(
              //   colors: [Colors.indigo, Colors.deepPurple],
              // ),
              backgroundColor: Colors.grey[850],
              child: FlashBar(
                message: Text('Login successful',
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              ),
            );
          }
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Timeline()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // return isNewUser ? createAccount() : viewAccount();
    return Scaffold();
  }
}
