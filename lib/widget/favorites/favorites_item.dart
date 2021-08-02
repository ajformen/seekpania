import 'package:challenge_seekpania/provider/activities.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';

class FavoritesItem extends StatefulWidget {
  final UserAccount? user;

  FavoritesItem({this.user});

  @override
  _FavoritesItemState createState() => _FavoritesItemState();
}

class _FavoritesItemState extends State<FavoritesItem> {
  late UserAccount currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = UserAccount(id: user!.uid);
    return Dismissible(
      key: ValueKey(widget.user!.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: 20.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to unfavorite this user?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Activities>(context, listen: false).deleteFave(widget.user!.id!);
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.user!.photoURL!),
              maxRadius: 25,
            ),
            title: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                widget.user!.firstName!,
                style: TextStyle(
                    fontSize: 14.0
                ),
              ),
            ),
            onTap: () {
              print(widget.user!.id);
            },
          ),
          SizedBox(height: 5.0,),
        ],
      ),
    );
  }
}
