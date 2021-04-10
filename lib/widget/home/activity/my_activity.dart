import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/activities.dart';
import 'package:challenge_seekpania/provider/selections/games.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';

import 'package:challenge_seekpania/widget/home/activity/my_activity_item.dart';

class MyActivity extends StatefulWidget {
  // static const routeName = './my-activity';

  @override
  _MyActivityState createState() => _MyActivityState();
}

class _MyActivityState extends State<MyActivity> {
  final user = FirebaseAuth.instance.currentUser;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Activities>(context).fetchCurrentUserActivity(user.uid).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  display(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(context),
        viewActivity()
      ],
    );
  }

  header(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () =>
                  Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_sharp,
                size: 30.0,
                // color: Color(0xffff3366),
                color: Colors.deepPurple[900],
              ),
            ),
            SizedBox(width: 75.0,),
            Text(
              'My Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4e4b6f),
              ),
            ),
          ],
        ),
        // Divider(color: Color(0xff9933ff)),
      ],
    );
  }

  noActivities() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any activities.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
          Text(
            'Make one today!.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewActivity() {
    // final games = Provider.of<Games>(context, listen: false).gameItems.map((g) => ActivityInterestItem(g.id, g.title)).toList();
    // final liveEvents = Provider.of<LiveEvents>(context, listen: false).eventItems.map((g) => ActivityInterestItem(g.id, g.title)).toList();
    // final interests = games + liveEvents;
    final activities = Provider.of<Activities>(context, listen: false).currentUserActivity.map((g) => MyActivityItem(
      g.id, g.caption, g.meetUpType, g.companionType,
      g.participants, g.scheduleDate, g.location, g.notes,
      g.creatorId, g.creatorName, g.creatorPhoto, g.type,
    )).toList();

    return Expanded(
      child: activities.length == 0 ? noActivities() : ListView(
        shrinkWrap: true,
        children: activities,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final gamesData = Provider.of<Games>(context);
    print('rebuilding...');
    return Scaffold(
      body: SafeArea(
        child: _isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Container(
          child: display(context),
        ),
      ),
    );
  }
}


