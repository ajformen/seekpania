import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_invite.dart';

import 'package:challenge_seekpania/widget/home/activity/view_activity.dart';

// import 'package:timeago/timeago.dart' as timeago;

class NotificationsItems extends StatefulWidget {
  final SelectInvite user;

  NotificationsItems({this.user});

  @override
  _NotificationsItemsState createState() => _NotificationsItemsState();
}

class _NotificationsItemsState extends State<NotificationsItems> {
  int id = 0;
  String invStatus;
  UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    print('USER ID');
    print(widget.user.id);
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
    currentUser = UserAccount(id: user.uid);
    String activityItemText;

    if (widget.user.type == 'invitation') {
      activityItemText = ' sent you an invitation';
    }


    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.user.creatorPhoto),
            maxRadius: 25,
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: widget.user.creatorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '$activityItemText',
                  ),
                ],
              ),
            ),
          ),
          onTap: () async{
            if (widget.user.invitationStatus == 'pending') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewActivity(user: widget.user))).then(onGoBack);
            } else if (widget.user.invitationStatus == 'accepted') {
              // Navigator.of(context).pop(context);
              Fluttertoast.showToast(
                  msg: "You already accepted this invitation!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 13.0
              );
            } else if (widget.user.invitationStatus == 'declined') {
              // Navigator.of(context).pop(context);
              Fluttertoast.showToast(
                  msg: "You have declined this invitation!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 13.0
              );
            }
          },
        ),
        SizedBox(height: 10.0,),
        // Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
