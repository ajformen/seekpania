import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/invitations.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/notifications_items.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  final user = FirebaseAuth.instance.currentUser;

  var _isInit = true;
  var _isLoading = false;
  int id = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Invitations>(context).fetchUserInvitations(user!.uid).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        viewNotifications(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
      child: Text(
        'Notifications',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          // color: Color(0xff4e4b6f),
        ),
      ),
    );
  }

  noNotifications() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any notifications.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewNotifications() {
    // final games = Provider.of<Games>(context, listen: false).gameItems.map((g) => ActivityInterestItem(g.id, g.title)).toList();
    // final liveEvents = Provider.of<LiveEvents>(context, listen: false).eventItems.map((g) => ActivityInterestItem(g.id, g.title)).toList();
    // final interests = games + liveEvents;

    final invitations = Provider.of<Invitations>(context, listen: false).currentUserInvitations.map((user) => NotificationsItems(user: user)).toList();

    return Expanded(
      child: invitations.length == 0 ? noNotifications() : ListView(
        shrinkWrap: true,
        children: invitations,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading ? Center(child: CircularProgressIndicator(),) : Container(
          child: display(),
        ),
      ),
    );
  }
}
