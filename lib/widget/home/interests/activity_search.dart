import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_activity.dart';
import 'package:challenge_seekpania/models/display_interests.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/home/interests/activity_search_items.dart';
import 'package:challenge_seekpania/widget/home/activity/my_activity.dart';

class ActivitySearch extends StatefulWidget {

  final String? searchID;
  final String? searchType;
  final SelectActivity? activity;
  // final String caption;
  // final String participants;

  // ActivitySearch({this.searchID, this.searchType, this.caption, this.participants});
  ActivitySearch({this.searchID, this.searchType, this.activity});

  @override
  _ActivitySearchState createState() => _ActivitySearchState();
}

class _ActivitySearchState extends State<ActivitySearch> {
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  late UserAccount currentUserID;

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    print('CAPTION');
    print(widget.activity!.caption);
    print('PARTICIPANTS');
    print(widget.activity!.participants);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Interest>(context).fetchUsersInterests(widget.searchID!, widget.searchType!).then((_) {
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
        displaySearchUsers(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {
              await Provider.of<Activities>(context, listen: false).deleteActivity(widget.activity!.id!);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: 30.0,
              color: Color(0xffff3366),
              // color: Colors.deepPurple[900],
            ),
          ),
          GestureDetector(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.deepPurple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyActivity()));
            },
          ),
        ],
      ),
    );
  }

  noUsers() {
    return Center(
      child: Text(
        'No user\'s that matches your interest.',
        style: TextStyle(
          fontSize: 13,
          color: Colors.red[600],
        ),
      ),
    );
  }

  displaySearchUsers() {
    // final interests = Provider.of<Interest>(context, listen: false).gameItems.map((g) => ActivityInterestItem(g.id, g.title)).toList();
    // final users = Provider.of<Interest>(context, listen: false).interestItems.map((user) => ActivitySearchItems(user: user, caption: widget.caption, participants: widget.participants)).toList();
    final users = Provider.of<Interest>(context, listen: false).interestItems.map((user) => ActivitySearchItems(user: user, activity: widget.activity!)).toList();

    return Expanded(
      child: users.length == 0 ? noUsers() : ListView(
        shrinkWrap: true,
        children: users,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Container(
          child: display(),
        ),
      ),
    );
  }
}
