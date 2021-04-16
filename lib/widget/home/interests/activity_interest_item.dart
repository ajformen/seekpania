import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

// import 'package:challenge_seekpania/widget/home/face_to_face.dart';
import 'package:challenge_seekpania/widget/home/dummy/face_to_face.dart';

class ActivityInterestItem extends StatefulWidget {
  final String id;
  final String interest;
  final String type;

  ActivityInterestItem(this.id, this.interest, this.type);

  @override
  _ActivityInterestItemState createState() => _ActivityInterestItemState();
}

class _ActivityInterestItemState extends State<ActivityInterestItem> {
  late UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              widget.interest,
              // style: TextStyle(
              //   color: Color(0xffff3366),
              // ),
            ),
          ),
          onTap: () {
            print(widget.id);
            print(widget.interest);
            print(widget.type);
            // Navigator.of(context).pushNamed(FaceToFace.routeName, arguments: widget.id);
            // Navigator.pushReplacement(
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    // FaceToFace(interestID: widget.id, interest: widget.interest, type: widget.type)
                FaceToFace(interestID: widget.id, interest: widget.interest, type: widget.type)
              )
            );
          },
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
