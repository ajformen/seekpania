import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/virtual/activity/activity_search_items.dart';

class ActivitySearch extends StatefulWidget {

  final String? searchID;
  final String? searchType;
  final SelectActivity? activity;

  ActivitySearch({this.searchID, this.searchType, this.activity});

  @override
  _ActivitySearchState createState() => _ActivitySearchState();
}

class _ActivitySearchState extends State<ActivitySearch> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  late UserAccount currentUser;

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('..................');
    print('ACTIVITY SEARCHHHHH');
    print('CAPTION');
    print(widget.activity!.caption);
    print('PARTICIPANTS');
    print(widget.activity!.participants);
    print('ACTIVITY ID');
    print(widget.activity!.id);
  }

  @override
  void didChangeDependencies() async {
    final user = FirebaseAuth.instance.currentUser;
    currentUser = UserAccount(id: user!.uid);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Interest>(context, listen: false).fetchUsersInterestsCountry(widget.searchID!, widget.searchType!, widget.activity!.location!).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  getStateLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    currentUser = UserAccount(id: user!.uid);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
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
            onTap: () async {
              final user = FirebaseAuth.instance.currentUser;
              currentUser = UserAccount(id: user!.uid);
              DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
              currentUser = UserAccount.fromDocument(doc);
              print('THE IDDDD');
              print(currentUser.id);
              print(currentUser.firstName);
              print(widget.activity!.caption);
              print('ACTIVITY ID');
              print(widget.activity!.id);
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
    final users = Provider.of<Interest>(context, listen: false).countryInterest.map((user) => ActivitySearchItems(user: user, activity: widget.activity!)).toList();

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
