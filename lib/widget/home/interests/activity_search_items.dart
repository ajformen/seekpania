import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/invitations.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/profile/UsersProfile.dart';

class ActivitySearchItems extends StatefulWidget {
  final UserAccount user;
  final SelectActivity activity;
  // final String caption;
  // final String participants;

  // ActivitySearchItems({this.user, this.caption, this.participants});
  ActivitySearchItems({this.user, this.activity});

  @override
  _ActivitySearchItemsState createState() => _ActivitySearchItemsState();
}

class _ActivitySearchItemsState extends State<ActivitySearchItems> {
  bool isSelected = false;
  DateTime timestamp = DateTime.now();
  String invId = Uuid().v4();

  selectedText() {
    return Text(
      'sent',
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: GestureDetector(
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoURL),
              maxRadius: 25,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UsersProfile(user: widget.user)
                  )
              );
            },
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              child: Text(
                '${widget.user.firstName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UsersProfile(user: widget.user)
                    )
                );
              },
            ),
          ),
          trailing: GestureDetector(
            child: isSelected ? selectedText() : Text(
              'invite',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),
            ),
            onTap: () async {
              await Provider.of<Invitations>(context, listen: false).addInvite(widget.activity, widget.user.id);

              setState(() {
                isSelected = true;
              });
            },
          ),
          // onTap: () {
          //
          // },
        ),
        SizedBox(height: 10,),
        // Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
