import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';

import 'package:challenge_seekpania/widget/admin/events/edit_event_screen.dart';

class EventItem extends StatelessWidget {
  final String id;
  final String title;

  EventItem(this.id, this.title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
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
                print('SELECTED GAME ID');
                print(id);
                print('GAME NAME');
                print(title);
                Navigator.of(context).pushNamed(EditEventScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await Provider.of<LiveEvents>(context, listen: false).deleteLiveEvent(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
