import 'package:challenge_seekpania/services/message_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/home/interests/activity_search_items.dart';

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
    print('ACTIVITYYYYY SEARCHHHH');
    print('CAPTION');
    print(widget.activity!.caption);
    print('PARTICIPANTS');
    print(widget.activity!.participants);
    print('ACTIVITY ID');
    print(widget.activity!.id);
    print('SEARCH ID');
    print(widget.searchID);
    print('SEARCH TYPE');
    print(widget.searchType);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final user = FirebaseAuth.instance.currentUser;
    currentUser = UserAccount(id: user!.uid);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    print('AJ CURRENT LOCATION - ACT SEARCH');
    print(currentUser.currentLocation);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Interest>(context, listen: false).fetchUsersInterests(widget.searchID!, widget.searchType!, currentUser.currentLocation!).then((_) {
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

              await usersRef.doc(currentUser.id).collection('activities').doc(widget.activity!.id).update({
                'going.${currentUser.id}' : true
              });

              double total = currentUser.points! - 3;
              await usersRef.doc(currentUser.id).update({
                'points': total,
              });

              MessageService(uid: user.uid).createChat(currentUser.firstName!, widget.activity!.caption!);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Fluttertoast.showToast(
                  msg: "Activity created successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 13.0
              );
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
