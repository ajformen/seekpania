import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/selections/select_games.dart';

import 'package:provider/provider.dart';


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
        // color: this.backgroundColor,
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


// class InterestBox extends StatelessWidget {
//   // final String text;
//   // final Color textColor;
//   // final Color backgroundColor;
//   //
//   // const InterestBox({Key key, this.text, this.textColor, this.backgroundColor}) : super(key: key);
//
//   // final AddInterestItem interItem;
//
//   // InterestBox(this.interItem);
//
//   final String id;
//   final String interestId;
//   final String title;
//
//   InterestBox(this.id, this.interestId, this.title);
//
//   @override
//   Widget build(BuildContext context) {
//     final game = Provider.of<SelectGames>(context);
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: 5,
//         horizontal: 15,
//       ),
//       decoration: BoxDecoration(
//         // color: this.backgroundColor,
//         color: Color(0xfff2e5ff),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         // game.title,
//         title,
//         style: TextStyle(
//           color: Color(0xff9933ff),
//           fontSize: 12.0,
//         ),
//       ),
//     );
//   }
// }

