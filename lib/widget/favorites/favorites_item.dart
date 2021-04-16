import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/home/activity/activity_details.dart';

class FavoritesItem extends StatefulWidget {
  UserAccount? user;

  FavoritesItem({this.user});

  @override
  _FavoritesItemState createState() => _FavoritesItemState();
}

class _FavoritesItemState extends State<FavoritesItem> {
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
              style: TextStyle(
                  fontSize: 14.0
                // color: Color(0xffff3366),
              ),
            ),
          ),
          onTap: () {
            print(widget.user!.id);
          },
        ),
      ],
    );
  }
}
