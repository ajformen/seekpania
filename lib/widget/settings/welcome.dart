import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:provider/provider.dart';
import 'package:challenge_seekpania/widget/timeline.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        displayMsgs(),
      ],
    );
  }

  displayMsgs() {
    return Container(
      padding: const EdgeInsets.only(top: 250.0),
      child: Center(
        child: Column(
          children: [
            Text(
              'Welcome back!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0
              ),
            ),
            SizedBox(height: 20.0,),
            InkWell(
              onTap: () async {
                final user = FirebaseAuth.instance.currentUser;
                UserAccount currentUser;
                currentUser = UserAccount(id: user!.uid);
                final activate = Provider.of<UserAccount>(context, listen: false);
                activate.activateAccount(currentUser.id!);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Timeline()));
              },
              child: Container(
                width: 130.0,
                height: 40.0,
                decoration: new BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple[900]!,
                  ),
                  color: Colors.deepPurple[900],
                  // shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: display(),
          ),
        )
    );
  }
}
