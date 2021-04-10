import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/selections/select_games.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/game.dart';
import 'package:challenge_seekpania/provider/selections/games.dart';

import 'package:challenge_seekpania/provider/interest.dart';

class SelectGameItem extends StatefulWidget {
  @override
  _SelectGameItemState createState() => _SelectGameItemState();
}

class _SelectGameItemState extends State<SelectGameItem> {
  Map selects;
  bool isPicked;

  _SelectGameItemState({this.selects, this.isPicked});

  UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user.uid);
    final game = Provider.of<SelectGames>(context);
    // final theGame = Provider.of<Game>(context);
    print(game.selects[currentUser.id]);
    isPicked = (game.selects[currentUser.id] == true);
    final itrst = Provider.of<Interest>(context);
    return GridTile(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: Colors.deepPurple[900],
            ),
            // color: game.isSelected ? Colors.deepPurple[900] : Colors.white,
            color: isPicked ? Colors.deepPurple[900] : Colors.white,
          ),
          padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
          child: Text(
            game.title,
            style: TextStyle(
              // color: game.isSelected ? Colors.white : Colors.black,
              color: isPicked ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          game.toggleSelectedStatus();
          // if (game.isSelected) {
          //   itrst.addItem(game.id, game.title);
          // } else {
          //   itrst.removeItem(game.id);
          // }
        },
      ),
    );
  }
}
