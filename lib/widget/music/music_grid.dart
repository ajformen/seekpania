import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/music/select_music_item.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/musics.dart';

class MusicGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final musicData = Provider.of<Musics>(context);
    final music = musicData.items;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0),
      itemCount: music.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (c) => games[i],
        value: music[i],
        child: SelectMusicItem(
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