import 'package:challenge_seekpania/models/select_activity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/home/activity/activity_details.dart';

class MyActivityItem extends StatefulWidget {
  final SelectActivity? info;

  MyActivityItem({
    this.info
  });

  @override
  _MyActivityItemState createState() => _MyActivityItemState();
}

class _MyActivityItemState extends State<MyActivityItem> {
  late UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('MY ACTIVITY ITEM');
    print(widget.info!.scheduleDate!);
    print(widget.info!.scheduleTime!);
  }

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              widget.info!.caption!,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          onTap: () {
            print(widget.info!.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ActivityDetails(
                          info: widget.info
                        )
                )
            );
          },
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
