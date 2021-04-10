import 'package:challenge_seekpania/page/header.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/admin/games/games_screen.dart';
import 'package:challenge_seekpania/widget/admin/events/events_screen.dart';
import 'package:challenge_seekpania/widget/admin/music/music_screen.dart';
import 'package:challenge_seekpania/widget/admin/movies/movies_screen.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {

  viewGames() {
    Navigator.of(context).pushNamed(GamesScreen.routeName);
  }

  viewEvents() {
    Navigator.of(context).pushNamed(EventsScreen.routeName);
  }

  viewMusic() {
    Navigator.of(context).pushNamed(MusicScreen.routeName);
  }

  viewMovies() {
    Navigator.of(context).pushNamed(MoviesScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titleText: "Manage"),
        body: ListView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 25.0, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Games', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {viewGames();},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Live Events', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {viewEvents();},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Music', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {viewMusic();},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Movies', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {viewMovies();},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Reading', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Relationships', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Fitness & Wellness', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Food & Drink', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Hobbies & Activities', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Shopping & Fashion', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {},
                    ),
                    Divider(color: Color(0xff9933ff)),
                    ListTile(
                      // leading: Icon(Icons.circle, color: Colors.deepPurple),
                      title: Text('Sports & Outdoors', style: TextStyle(color: Colors.grey[800]),),
                      onTap: () {},
                    ),
                    Divider(color: Color(0xff9933ff)),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
