import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/selections/select_movies.dart';

import 'package:provider/provider.dart';

import 'package:challenge_seekpania/provider/interest.dart';

class SelectMoviesItem extends StatefulWidget {
  @override
  _SelectMoviesItemState createState() => _SelectMoviesItemState();
}

class _SelectMoviesItemState extends State<SelectMoviesItem> {
  Map? selects;
  bool? isPicked;

  _SelectMoviesItemState({this.selects, this.isPicked});

  UserAccount? currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    final movies = Provider.of<SelectMovies>(context);
    // final theGame = Provider.of<Game>(context);
    print(movies.selects[currentUser!.id]);
    isPicked = (movies.selects[currentUser!.id] == true);
    final itrst = Provider.of<Interest>(context);
    return GridTile(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: Colors.deepPurple[900]!,
            ),
            // color: game.isSelected ? Colors.deepPurple[900] : Colors.white,
            color: isPicked! ? Colors.deepPurple[900] : Colors.white,
          ),
          padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
          child: Text(
            movies.title!,
            style: TextStyle(
              // color: game.isSelected ? Colors.white : Colors.black,
              color: isPicked! ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          movies.toggleSelectedStatus();
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
