import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/selections/select_music.dart';

import 'package:provider/provider.dart';


class SelectMusicItem extends StatefulWidget {
  @override
  _SelectMusicItemState createState() => _SelectMusicItemState();
}

class _SelectMusicItemState extends State<SelectMusicItem> {
  Map? selects;
  bool? isPicked;

  _SelectMusicItemState({this.selects, this.isPicked});

  UserAccount? currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    final music = Provider.of<SelectMusic>(context);
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
