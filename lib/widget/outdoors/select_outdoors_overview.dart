import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/outdoors.dart';

import 'package:challenge_seekpania/widget/outdoors/outdoors_grid.dart';



class SelectOutdoorsOverview extends StatefulWidget {
  static const routeName = '/select-outdoors-overview';
  @override
  _SelectOutdoorsOverviewState createState() => _SelectOutdoorsOverviewState();
}

class _SelectOutdoorsOverviewState extends State<SelectOutdoorsOverview> {
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
      Provider.of<Outdoors>(context).fetchAndSetScreen().then((_) {
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
            "Outdoors",
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
      ) : OutdoorsGrid(),
    );
  }
}


