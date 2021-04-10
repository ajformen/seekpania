import 'dart:ui';

import 'package:search_page/search_page.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/selections/select_music.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/musics.dart';

import 'package:challenge_seekpania/widget/admin/music/music_item.dart';
import 'package:challenge_seekpania/widget/admin/music/edit_music_screen.dart';

class MusicScreen extends StatelessWidget {
  static const routeName = './music-screen';

  Future<void> _refreshMusic(BuildContext context) async {
    await Provider.of<Musics>(context, listen: false).fetchAndSetMusic();
  }

  @override
  Widget build(BuildContext context) {
    // final gamesData = Provider.of<Games>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music', style: TextStyle(fontSize: 18.0),),
        actions: <Widget>[
          Consumer<Musics>(
            builder: (_, musicData, ch) =>
                IconButton(
                  icon: const Icon(
                      Icons.search
                  ),
                  onPressed: () => showSearch(
                      context: context,
                      delegate: SearchPage<SelectMusic>(
                        searchLabel: 'Search Music',
                        builder: (game) => ListTile(
                          title: Text(game.title),
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
                                    print('MUSIC ID SEARCH:');
                                    print(game.id);
                                    Navigator.of(context).pushNamed(EditMusicScreen.routeName, arguments: game.id);
                                  },
                                  color: Theme.of(context).primaryColor,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await Provider.of<Musics>(context, listen: false).deleteMusic(game.id);
                                  },
                                  color: Theme.of(context).errorColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        filter: (game) => [
                          game.title,
                        ],
                        items: musicData.items,
                      )
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(
                Icons.add
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditMusicScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshMusic(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center (
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () => _refreshMusic(context),
          child: Consumer<Musics>(
            builder: (ctx, musicData, _) => Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: ListView.builder(
                itemCount: musicData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    MusicItem(
                      musicData.items[i].id,
                      musicData.items[i].title,
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


