import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/home/activity/activity_details.dart';

class MyActivityItem extends StatefulWidget {
  final String id;
  final String caption;
  final String meetUpType;
  final String companionType;
  final int participants;
  final String schedule;
  final String location;
  final String notes;
  final String creatorId, creatorName, creatorPhoto, type;

  MyActivityItem(
      this.id, this.caption, this.meetUpType, this.companionType,
      this.participants, this.schedule, this.location, this.notes,
      this.creatorId, this.creatorName, this.creatorPhoto, this.type
  );

  @override
  _MyActivityItemState createState() => _MyActivityItemState();
}

class _MyActivityItemState extends State<MyActivityItem> {
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
              widget.caption,
              style: TextStyle(
                fontSize: 14.0
                // color: Color(0xffff3366),
              ),
            ),
          ),
          onTap: () {
            print(widget.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ActivityDetails(
                          id: widget.id, caption: widget.caption, meetUpType: widget.meetUpType, companionType: widget.companionType,
                          participants: widget.participants, schedule: widget.schedule, location: widget.location, notes: widget.notes,
                          creatorId: widget.creatorId, creatorName: widget.creatorName, creatorPhoto: widget.creatorPhoto, type: widget.type,
                        )
                )
            );
          },
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
