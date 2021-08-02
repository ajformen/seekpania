import 'dart:ui';

import 'package:search_page/search_page.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/selections/select_games.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/games.dart';

import 'package:challenge_seekpania/widget/admin/games/game_item.dart';
import 'package:challenge_seekpania/widget/admin/games/edit_game_screen.dart';

class GamesScreen extends StatelessWidget {
  static const routeName = './games-screen';

  Future<void> _refreshGames(BuildContext context) async {
    await Provider.of<Games>(context, listen: false).fetchAndSetGames();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games', style: TextStyle(fontSize: 18.0),),
        actions: <Widget>[
          Consumer<Games>(
              builder: (_, gamesData, ch) =>
                  IconButton(
                    icon: const Icon(
                        Icons.search
                    ),
                    onPressed: () => showSearch(
                        context: context,
                        delegate: SearchPage<SelectGames>(
                          searchLabel: 'Search Games',
                          builder: (game) => ListTile(
                            title: Text(game.title!),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      print('GAME ID SEARCH:');
                                      print(game.id);
                                      Navigator.of(context).pushNamed(EditGameScreen.routeName, arguments: game.id);
                                    },
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await Provider.of<Games>(context, listen: false).deleteGame(game.id!);
                                    },
                                    color: Theme.of(context).errorColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          filter: (game) => [
                            game.title.toString(),
                          ],
                          items: gamesData.items,
                        )
                    ),
                  ),
          ),
          IconButton(
            icon: const Icon(
                Icons.add
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditGameScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshGames(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center (
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () => _refreshGames(context),
          child: Consumer<Games>(
            builder: (ctx, gamesData, _) => Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: ListView.builder(
                itemCount: gamesData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    GameItem(
                      gamesData.items[i].id!,
                      gamesData.items[i].title!,
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


