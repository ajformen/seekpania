import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/rate.dart';

import 'package:challenge_seekpania/widget/points/points_item.dart';

class PointsScreen extends StatefulWidget {

  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late UserAccount currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Rate>(context).fetchCurrentUserPoints(user!.uid).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Widget buildLoading() => Center(child: CircularProgressIndicator());

  display(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(context),
        totalPoints(),
        viewPoints()
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
            SizedBox(width: 75.0,),
            Text(
              'My Points',
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

  totalPoints() {
    return FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buildLoading();
          }
          currentUser = UserAccount.fromDocument(snapshot.data!);
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: Container(
              width: 130.0,
              height: 40.0,
              decoration: new BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple[700]!,
                ),
                color: Colors.deepPurple[700],
                // shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${currentUser.points} points',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  noPoints() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 200.0),
      child: Column(
        children: [
          Text(
            'To earn points someone has to rate you.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewPoints() {
    final points = Provider.of<Rate>(context, listen: false).userPoints.map((g) => PointsItem(g.id!, g.rate!, g.feedback!)).toList();

    return _isLoading ? Center(
      child: CircularProgressIndicator(),
    ) : Expanded(
      child: points.length == 0 ? noPoints() : ListView(
        shrinkWrap: true,
        children: points,
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


