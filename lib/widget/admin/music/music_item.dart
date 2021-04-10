import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/musics.dart';

import 'package:challenge_seekpania/widget/admin/music/edit_music_screen.dart';

class MusicItem extends StatelessWidget {
  final String id;
  final String title;

  MusicItem(this.id, this.title);

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
                print('SELECTED MUSIC ID');
                print(id);
                print('MUSIC NAME');
                print(title);
                Navigator.of(context).pushNamed(EditMusicScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await Provider.of<Musics>(context, listen: false).deleteMusic(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
