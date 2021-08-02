import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/selections/select_games.dart';

import 'package:provider/provider.dart';

class SelectGameItem extends StatefulWidget {
  @override
  _SelectGameItemState createState() => _SelectGameItemState();
}

class _SelectGameItemState extends State<SelectGameItem> {
  Map? selects;
  bool? isPicked;

  _SelectGameItemState({this.selects, this.isPicked});

  late UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    final game = Provider.of<SelectGames>(context);
    print(game.selects[currentUser.id]);
    isPicked = (game.selects[currentUser.id] == true);
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
            game.title!,
            style: TextStyle(
              color: isPicked! ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          game.toggleSelectedStatus();
        },
      ),
    );
  }
}
