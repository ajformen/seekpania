import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/readings.dart';

import 'package:challenge_seekpania/widget/reading/reading_grid.dart';



class SelectReadingOverview extends StatefulWidget {
  static const routeName = '/select-reading-overview';
  @override
  _SelectReadingOverviewState createState() => _SelectReadingOverviewState();
}

class _SelectReadingOverviewState extends State<SelectReadingOverview> {
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
      Provider.of<Readings>(context).fetchAndSetScreen().then((_) {
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
            "Reading",
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
      ) : ReadingGrid(),
    );
  }
}


