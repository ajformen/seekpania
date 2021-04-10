import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/live_events/select_live_event_item.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';

class LiveEventsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final liveEventsData = Provider.of<LiveEvents>(context);
    final liveEvents = liveEventsData.items;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0),
      itemCount: liveEvents.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (c) => liveEvents[i],
        child: SelectLiveEventItem(
          // games[i].id,
          // games[i].title,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 6 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 7,
      ),
    );
  }
}