import 'package:challenge_seekpania/page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account.dart';

class AccountBanned extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Your account has been banned due to your bad behavior.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50.0),
              child: InkWell(
                onTap: () async {
                  await googleSignIn.signOut();

                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false);
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
