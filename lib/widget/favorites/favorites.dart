import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/favorites/favorites_item.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  final user = FirebaseAuth.instance.currentUser;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Activities>(context).fetchFaveUsers(user.uid).then((_) {
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
        viewFavorites()
      ],
    );
  }

  header() {
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
            SizedBox(width: 40.0,),
            Text(
              'My Fave Companions',
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

  noFavorites() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any favorite companions.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
          Text(
            'Fave one today!.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewFavorites() {
    final favorites = Provider.of<Activities>(context, listen: false).faveUsers.map((user) => FavoritesItem(user: user)).toList();

    return Expanded(
      child: favorites.length == 0 ? noFavorites() : ListView(
        shrinkWrap: true,
        children: favorites,
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
