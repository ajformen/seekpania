import 'dart:ui';
import 'package:challenge_seekpania/models/selections/select_sports.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';


class SelectSportsItem extends StatefulWidget {
  @override
  _SelectSportsItemState createState() => _SelectSportsItemState();
}

class _SelectSportsItemState extends State<SelectSportsItem> {
  Map? selects;
  bool? isPicked;

  _SelectSportsItemState({this.selects, this.isPicked});

  UserAccount? currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    final music = Provider.of<SelectSports>(context);
    print(music.selects[currentUser!.id]);
    isPicked = (music.selects[currentUser!.id] == true);
    return GridTile(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: Colors.deepPurple[900]!,
            ),
            color: isPicked! ? Colors.deepPurple[900] : Colors.white,
          ),
          padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
          child: Text(
            music.title!,
            style: TextStyle(
              color: isPicked! ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          music.toggleSelectedStatus();
        },
      ),
    );
  }
}
