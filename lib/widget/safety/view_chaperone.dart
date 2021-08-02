import 'package:challenge_seekpania/provider/selections/chaperones.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:challenge_seekpania/widget/safety/chaperone_items.dart';

class ViewChaperone extends StatefulWidget {
  @override
  _ViewChaperoneState createState() => _ViewChaperoneState();
}

class _ViewChaperoneState extends State<ViewChaperone> {

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
      Provider.of<Chaperones>(context).fetchChaperones(user!.uid).then((_) {
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
        viewChaperones(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
      child: Text(
        'Chaperones',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  noChaperones() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any chaperones.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewChaperones() {
    final chaperones = Provider.of<Chaperones>(context, listen: false).chaperoneLists.map((info) => ChaperoneItems(info: info)).toList();

    return Expanded(
      child: chaperones.length == 0 ? noChaperones() : ListView(
        shrinkWrap: true,
        children: chaperones,
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
