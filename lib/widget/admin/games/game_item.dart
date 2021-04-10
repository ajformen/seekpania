import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/selections/games.dart';

import 'package:challenge_seekpania/widget/admin/games/edit_game_screen.dart';

class GameItem extends StatelessWidget {
  final String id;
  final String title;

  GameItem(this.id, this.title);

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
                Navigator.of(context).pushNamed(EditGameScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await Provider.of<Games>(context, listen: false).deleteGame(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
