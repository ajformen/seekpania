import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/movies.dart';

import 'package:challenge_seekpania/widget/admin/movies/edit_movies_screen.dart';

class MoviesItem extends StatelessWidget {
  final String id;
  final String title;

  MoviesItem(this.id, this.title);

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
                print('SELECTED MOVIES ID');
                print(id);
                print('MOVIES NAME');
                print(title);
                Navigator.of(context).pushNamed(EditMoviesScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await Provider.of<Movies>(context, listen: false).deleteMovies(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
