import 'package:challenge_seekpania/widget/live_events/live_events_grid.dart';
import 'package:challenge_seekpania/page/header.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';

class SelectLiveEventsOverview extends StatefulWidget {
  static const routeName = '/select-event-overview';
  @override
  _SelectLiveEventsOverviewState createState() => _SelectLiveEventsOverviewState();
}

class _SelectLiveEventsOverviewState extends State<SelectLiveEventsOverview> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<LiveEvents>(context).fetchAndSetLiveEvents().then((_) {
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
      appBar: header(context, titleText: 'Live Events'),
      body: _isLoading ? Center (
        child: CircularProgressIndicator(),
      ) : LiveEventsGrid(),
    );
  }
}


