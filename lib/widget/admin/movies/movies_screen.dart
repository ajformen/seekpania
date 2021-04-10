import 'dart:ui';

import 'package:search_page/search_page.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/selections/select_movies.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/movies.dart';

import 'package:challenge_seekpania/widget/admin/movies/movies_item.dart';
import 'package:challenge_seekpania/widget/admin/movies/edit_movies_screen.dart';

class MoviesScreen extends StatelessWidget {
  static const routeName = './movies-screen';

  Future<void> _refreshMovies(BuildContext context) async {
    await Provider.of<Movies>(context, listen: false).fetchAndSetMovies();
  }

  @override
  Widget build(BuildContext context) {
    // final gamesData = Provider.of<Games>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies', style: TextStyle(fontSize: 18.0),),
        actions: <Widget>[
          Consumer<Movies>(
            builder: (_, moviesData, ch) =>
                IconButton(
                  icon: const Icon(
                      Icons.search
                  ),
                  onPressed: () => showSearch(
                      context: context,
                      delegate: SearchPage<SelectMovies>(
                        searchLabel: 'Search Movies',
                        builder: (movie) => ListTile(
                          title: Text(movie.title),
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
                                    print('MOVIE ID SEARCH:');
                                    print(movie.id);
                                    Navigator.of(context).pushNamed(EditMoviesScreen.routeName, arguments: movie.id);
                                  },
                                  color: Theme.of(context).primaryColor,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await Provider.of<Movies>(context, listen: false).deleteMovies(movie.id);
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
                        items: moviesData.items,
                      )
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(
                Icons.add
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditMoviesScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshMovies(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center (
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () => _refreshMovies(context),
          child: Consumer<Movies>(
            builder: (ctx, movieData, _) => Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: ListView.builder(
                itemCount: movieData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    MoviesItem(
                      movieData.items[i].id,
                      movieData.items[i].title,
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


