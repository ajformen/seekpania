import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';

import 'package:challenge_seekpania/widget/home/interests/activity_interest_item.dart';

class ActivityInterestScreen extends StatefulWidget {
  static const routeName = './activity-interest-screen';

  @override
  _ActivityInterestScreenState createState() => _ActivityInterestScreenState();
}

class _ActivityInterestScreenState extends State<ActivityInterestScreen> {
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
    }
    _isInit = false;

    super.didChangeDependencies();
  }

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
        color: Colors.deepPurple[900],
      ),
    );
  }

  ask(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select an interest to match',
          style: TextStyle(
            color: Colors.deepPurple[900],
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
    final interests = Provider.of<Interest>(context, listen: false).currentUserInterests.map((g) => ActivityInterestItem(g.id!, g.title!, g.type!)).toList();

    return _isLoading ? Center(
      child: CircularProgressIndicator(),
    ) : Expanded(
      child: interests.length == 0 ? noInterests() : ListView(
        shrinkWrap: true,
        children: interests,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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


