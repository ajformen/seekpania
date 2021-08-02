import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/home/activity/people_going_item.dart';

class PeopleGoing extends StatefulWidget {
  final String? activityId;
  final String? creatorId;

  PeopleGoing({this.activityId, this.creatorId});

  @override
  _PeopleGoingState createState() => _PeopleGoingState();
}

class _PeopleGoingState extends State<PeopleGoing> {

  final user = FirebaseAuth.instance.currentUser;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Activities>(context).fetchSpecificActivity(widget.creatorId!, widget.activityId!).then((_) {
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
        viewParticipants(),
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
                color: Colors.deepPurple[900],
              ),
            ),
            SizedBox(width: 65.0,),
            Text(
              'People going ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4e4b6f),
              ),
            ),
            Text(
              '(',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4e4b6f),
              ),
            ),
            Consumer<Activities>(
                builder: (ctx, activitiesData, _) => Text(
                  activitiesData.specificActivity.length.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4e4b6f),
                  ),
                ),
            ),
            Text(
              ')',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4e4b6f),
              ),
            ),
          ],
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }

  viewParticipants() {
    final activities = Provider.of<Activities>(context, listen: false).specificActivity.map((user) => PeopleGoingItem(user: user)).toList();

    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: activities,
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
          child: display(context),
        ),
      ),
    );
  }
}
