import 'package:challenge_seekpania/widget/account_banned.dart';
import 'package:challenge_seekpania/widget/settings/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/check_user.dart';
import 'package:challenge_seekpania/widget/notifications.dart';
import 'package:challenge_seekpania/widget/account.dart';
import 'package:challenge_seekpania/widget/create_activity.dart';
import 'package:challenge_seekpania/widget/messages/notify/messaging.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  _checkUserStatus() async{
    final user = FirebaseAuth.instance.currentUser;
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    print('USERS STATUS NOW!!!!');
    print(currentUser.userStatus);
    if (currentUser.userStatus == 'BANNED') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AccountBanned()
          )
      );
    } else if (currentUser.userStatus == 'Deactivated') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WelcomeScreen()
          )
      );
    }
  }

  int _selectedIndex = 0;


  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      // CustomPaint(painter: BackgroundPainter()),
      Center(child: CircularProgressIndicator()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoading();
        }
        UserAccount currentUser = UserAccount.fromDocument(snapshot.data!);
        print('TIMELINE CURRENT USER ID: ');
        print(currentUser.id);
        print(currentUser.firstName);

        List<Widget> _widgetOptions = [CreateActivity(), Notifications(), Messaging(), Account(accountID: currentUser.id)];
        return Scaffold(
          body: PageView(
            children: <Widget>[
              _widgetOptions.elementAt(_selectedIndex),
            ],
          ),
          bottomNavigationBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.notifications
                ),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                ),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
          ),
        );
      }
    );
  }

}
