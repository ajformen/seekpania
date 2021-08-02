import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/profile/view_other_users_profile.dart';

class PeopleGoingItem extends StatefulWidget {
  final UserAccount? user;

  PeopleGoingItem({this.user});

  @override
  _PeopleGoingItemState createState() => _PeopleGoingItemState();
}

class _PeopleGoingItemState extends State<PeopleGoingItem> {
  late UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.user!.photoURL!),
            maxRadius: 25,
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              widget.user!.firstName!,
            ),
          ),
          onTap: () {
            print(widget.user!.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewOtherUsersProfile(user: widget.user!)
                )
            );
          },
        ),
        SizedBox(height: 10,),
        // Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
