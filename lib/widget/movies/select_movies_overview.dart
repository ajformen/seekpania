import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/movies.dart';

import 'package:challenge_seekpania/widget/movies/movies_grid.dart';

class SelectMoviesOverview extends StatefulWidget {
  static const routeName = '/select-movies-overview';
  @override
  _SelectMoviesOverviewState createState() => _SelectMoviesOverviewState();
}

class _SelectMoviesOverviewState extends State<SelectMoviesOverview> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Movies>(context).fetchAndSetMovies().then((_) {
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
      appBar: AppBar(
        title: Center(
          child: Text(
            "Movies",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green[300],
            ),
          ),
        ],
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : MoviesGrid(),
    );
  }
}


