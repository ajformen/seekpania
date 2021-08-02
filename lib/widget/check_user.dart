import 'package:challenge_seekpania/widget/terms_and_conditions.dart';
import 'package:flash/flash.dart';
import 'package:challenge_seekpania/widget/timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class CheckUser extends StatefulWidget {

  @override
  _CheckUserState createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  @override
  void initState() {
    super.initState();
    setState(() {

    });
    createUserInFirestore();
  }

  @override
  void dispose() {
    super.dispose();
    print('DISPOSE CHECK USER');
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    // final GoogleSignInAccount user = googleSignIn.currentUser;
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.uid).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      // await Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => CreateAccount()));
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TermsAndConditionsScreen()));
    } else {
      showFlash(
          context: context,
          duration: const Duration(seconds: 1),
          builder: (context, controller) {
            return Flash.bar(
              controller: controller,
              // backgroundGradient: LinearGradient(
              //   colors: [Colors.indigo, Colors.deepPurple],
              // ),
              backgroundColor: Colors.grey[850]!,
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
