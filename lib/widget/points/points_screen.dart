import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/rate.dart';

import 'package:challenge_seekpania/widget/points/points_item.dart';

class PointsScreen extends StatefulWidget {
  // static const routeName = './activity-interest-screen';

  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Rate>(context).fetchCurrentUserPoints(user.uid).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
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
                // color: Color(0xffff3366),
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

  noPoints() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any points.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
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
    final points = Provider.of<Rate>(context, listen: false).userPoints.map((g) => PointsItem(g.id, g.rate)).toList();

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


