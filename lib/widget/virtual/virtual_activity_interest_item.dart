import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/virtual/virtual_gathering.dart';

class VirtualActivityInterestItem extends StatefulWidget {
  final String id;
  final String interest;
  final String type;

  VirtualActivityInterestItem(this.id, this.interest, this.type);

  @override
  _VirtualActivityInterestItemState createState() => _VirtualActivityInterestItemState();
}

class _VirtualActivityInterestItemState extends State<VirtualActivityInterestItem> {
  UserAccount? currentUser;
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
            ),
          ),
          onTap: () {
            print(widget.id);
            print(widget.interest);
            print(widget.type);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VirtualGathering(interestID: widget.id, interest: widget.interest, type: widget.type)
              )
            );
          },
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
