import 'dart:async';
import 'package:challenge_seekpania/models/selections/select_chaperone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

class ChaperoneItems extends StatefulWidget {
  final SelectChaperone? info;

  ChaperoneItems({this.info});

  @override
  _ChaperoneItemsState createState() => _ChaperoneItemsState();
}

class _ChaperoneItemsState extends State<ChaperoneItems> {
  int id = 0;
  String? invStatus;
  UserAccount? currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    print('CHAPERONE ID');
    print(widget.info!.id);
    super.initState();
  }

  void refreshData() {
    id++;
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(
              widget.info!.name!.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              widget.info!.name!,
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              widget.info!.relationship!,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () {

          },
        ),
        SizedBox(height: 10.0,),
        // Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
