import 'package:challenge_seekpania/page/header.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/musics.dart';

import 'package:challenge_seekpania/widget/music/music_grid.dart';



class SelectMusicOverview extends StatefulWidget {
  static const routeName = '/select-music-overview';
  @override
  _SelectMusicOverviewState createState() => _SelectMusicOverviewState();
}

class _SelectMusicOverviewState extends State<SelectMusicOverview> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Games>(context).fetchAndSetGames(); -- THIS WON'T WORK
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Musics>(context).fetchAndSetMusic().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: header(context, titleText: 'Games'),
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Music",
            style: TextStyle(
              // color: Colors.deepPurple,
              fontSize: 18.0,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(ViewInterests.routeName);
            },
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green[300],
            ),
          ),
        ],
      ),
      // body: ChangeNotifierProvider(
      //   create: (context) => Games(),
      //   child: GamesGrid(),
      // ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : MusicGrid(),
    );
  }
}


