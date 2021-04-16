import 'dart:ui';

import 'package:search_page/search_page.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/selections/select_live_event.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';

import 'package:challenge_seekpania/widget/admin/events/event_item.dart';
import 'package:challenge_seekpania/widget/admin/events/edit_event_screen.dart';

class EventsScreen extends StatelessWidget {
  static const routeName = './events-screen';

  Future<void> _refreshEvents(BuildContext context) async {
    await Provider.of<LiveEvents>(context, listen: false).fetchAndSetLiveEvents();
  }

  @override
  Widget build(BuildContext context) {
    // final gamesData = Provider.of<LiveEvents>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events', style: TextStyle(fontSize: 18.0),),
        actions: <Widget>[
          Consumer<LiveEvents>(
              builder: (_, eventsData, ch) =>
                  IconButton(
                    icon: const Icon(
                        Icons.search
                    ),
                    onPressed: () => showSearch(
                        context: context,
                        delegate: SearchPage<SelectLiveEvent>(
                          searchLabel: 'Search Events',
                          builder: (event) => ListTile(
                            title: Text(event.title!),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             EditGameScreen(arguments: id)
                                      //     )
                                      // );
                                      print('EVENT ID SEARCH:');
                                      print(event.id);
                                      Navigator.of(context).pushNamed(EditEventScreen.routeName, arguments: event.id);
                                    },
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await Provider.of<LiveEvents>(context, listen: false).deleteLiveEvent(event.id!);
                                    },
                                    color: Theme.of(context).errorColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          filter: (event) => [
                            event.title.toString(),
                          ],
                          items: eventsData.items,
                        )
                    ),
                  ),
          ),
          IconButton(
            icon: const Icon(
                Icons.add
            ),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             EditGameScreen()
              //     )
              // );
              Navigator.of(context).pushNamed(EditEventScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshEvents(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center (
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () => _refreshEvents(context),
          child: Consumer<LiveEvents>(
            builder: (ctx, eventsData, _) => Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: ListView.builder(
                itemCount: eventsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    EventItem(
                      eventsData.items[i].id!,
                      eventsData.items[i].title!,
                    ),
                    Divider(color: Color(0xff9933ff)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


