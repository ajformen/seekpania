import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/movies/select_movies_item.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/movies.dart';

class MoviesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesData = Provider.of<Movies>(context);
    final movies = moviesData.items;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0),
      itemCount: movies.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (c) => games[i],
        value: movies[i],
        child: SelectMoviesItem(
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