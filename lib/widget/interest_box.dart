import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

class InterestBox extends StatefulWidget {
  final String interest;

  InterestBox(this.interest);

  @override
  _InterestBoxState createState() => _InterestBoxState();
}

class _InterestBoxState extends State<InterestBox> {

  late UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Color(0xfff2e5ff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        // game.title,
        '${widget.interest}',
        style: TextStyle(
          color: Color(0xff9933ff),
          fontSize: 12.0,
        ),
      ),
    );
  }
}

