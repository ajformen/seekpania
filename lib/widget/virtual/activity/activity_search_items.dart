import 'package:challenge_seekpania/widget/settings/deactivate_account.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/invitations.dart';

import 'package:challenge_seekpania/widget/profile/UsersProfile.dart';

class ActivitySearchItems extends StatefulWidget {
  final UserAccount? user;
  final SelectActivity? activity;

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
              backgroundImage: NetworkImage(widget.user!.photoURL!),
              maxRadius: 25,
            ),
            onTap: () {
              if (widget.user!.userStatus == 'Deactivated') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DeactivateAccount()
                    )
                );
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UsersProfile(user: widget.user!)
                    )
                );
              }
            },
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              child: Text(
                '${widget.user!.firstName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              onTap: () {
                if (widget.user!.userStatus == 'Deactivated') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DeactivateAccount()
                      )
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UsersProfile(user: widget.user!)
                      )
                  );
                }
              },
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              '${widget.user!.country}',
              style: TextStyle(
                fontSize: 12.0,
              ),
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
              await Provider.of<Invitations>(context, listen: false).addInvite(widget.activity!, widget.user!.id!);

              setState(() {
                isSelected = true;
              });
            },
          ),
        ),
      ],
    );
  }
}
