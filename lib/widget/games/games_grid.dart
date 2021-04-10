import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/games/select_game_item.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/games.dart';

class GamesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gamesData = Provider.of<Games>(context);
    final games = gamesData.items;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0),
      itemCount: games.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (c) => games[i],
        value: games[i],
        child: SelectGameItem(
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