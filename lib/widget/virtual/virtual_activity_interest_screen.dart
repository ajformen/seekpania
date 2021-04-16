import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/selections/select_games.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';
import 'package:challenge_seekpania/provider/selections/games.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';

import 'package:challenge_seekpania/widget/virtual/virtual_activity_interest_item.dart';

class VirtualActivityInterestScreen extends StatefulWidget {
  static const routeName = './virtual-activity-interest-screen';

  @override
  _VirtualActivityInterestScreenState createState() => _VirtualActivityInterestScreenState();
}

class _VirtualActivityInterestScreenState extends State<VirtualActivityInterestScreen> {
  final user = FirebaseAuth.instance.currentUser;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Interest>(context).fetchCurrentUserInterests(user!.uid).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      // Provider.of<LiveEvents>(context).fetchLiveEventInterests().then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  // Future<void> _refreshInterests(BuildContext context) async {
  //   await Provider.of<Games>(context, listen: false).fetchGameInterests();
  //   await Provider.of<LiveEvents>(context, listen: false).fetchLiveEventInterests();
  // }

  display(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(context),
        ask(context),
        viewInterest(context)
      ],
    );
  }

  header(BuildContext context) {
    return IconButton(
      onPressed: () =>
          Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_sharp,
        size: 30.0,
        // color: Color(0xffff3366),
        color: Colors.deepPurple[900],
      ),
    );
  }

  ask(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select an interest to match',
          style: TextStyle(
            // color: Color(0xffff3366),
            color: Colors.deepPurple[900],
            // fontSize: 16.0,
            fontWeight: FontWeight.bold
          ),
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }

  noInterests() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any selected interests.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
          Text(
            'Select an interest to the Profile Section.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewInterest(BuildContext context) {
    // final games = Provider.of<Games>(context, listen: false).gameItems.map((g) => ActivityInterestItem(g.id, g.title)).toList();
    // final liveEvents = Provider.of<LiveEvents>(context, listen: false).eventItems.map((g) => ActivityInterestItem(g.id, g.title)).toList();
    // final interests = games + liveEvents;
    final interests = Provider.of<Interest>(context, listen: false).currentUserInterests.map((g) => VirtualActivityInterestItem(g.id!, g.title!, g.type!)).toList();

    return _isLoading ? Center(
      child: CircularProgressIndicator(),
    ) : Expanded(
      child: interests.length == 0 ? noInterests() : ListView(
        shrinkWrap: true,
        children: interests,
      ),
    );
    // Wrap(
    //   // spacing: 2,
    //   // runSpacing: 2,
    //   // direction: Axis.horizontal,
    //   // children: <Widget>[...interests, Divider(color: Color(0xff9933ff))],
    //   children: interests,
    // );
  }

  @override
  Widget build(BuildContext context) {
    // final gamesData = Provider.of<Games>(context);
    print('rebuilding...');
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: display(context),
        ),
      ),
    );
  }
}


