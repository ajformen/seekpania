import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/selections/select_live_event.dart';
import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';

class SelectLiveEventItem extends StatefulWidget {

  @override
  _SelectLiveEventItemState createState() => _SelectLiveEventItemState();
}

class _SelectLiveEventItemState extends State<SelectLiveEventItem> {
  Map? selects;
  bool?isPicked;

  _SelectLiveEventItemState({this.selects, this.isPicked});


  UserAccount? currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    final liveEvent = Provider.of<SelectLiveEvent>(context);
    isPicked = (liveEvent.selects[currentUser!.id] == true);
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
            liveEvent.title!,
            style: TextStyle(
              color: isPicked! ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          liveEvent.toggleSelectedStatus();
        },
      ),
    );
  }
}
