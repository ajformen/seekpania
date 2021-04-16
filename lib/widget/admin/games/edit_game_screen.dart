import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/models/selections/select_games.dart';
import 'package:challenge_seekpania/provider/selections/games.dart';

class EditGameScreen extends StatefulWidget {
  static const routeName = '/edit-game';

  @override
  _EditGameScreenState createState() => _EditGameScreenState();
}

class _EditGameScreenState extends State<EditGameScreen> {
  final _form = GlobalKey<FormState>();
  var _editedGame = SelectGames(id: null, title: '');
  var _initValues = {
    'title': '',
  };
  var _isInit = true;
  var _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedGame.id != null) {
      await Provider.of<Games>(context, listen: false).updateGame(_editedGame.id!, _editedGame);
    } else {
      try {
        await Provider.of<Games>(context, listen: false).addGame(_editedGame);
      } catch (error) {
        print(error);
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // gameId IS NULL FIX THIS!
      final gameId = ModalRoute.of(context)!.settings.arguments as String;
      if (gameId != null) {
        _editedGame = Provider.of<Games>(context, listen: false).findById(gameId);
        _initValues = {
          'title': _editedGame.title.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Game'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading ? Center(
          child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title'
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide the name of the game.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedGame = SelectGames(
                    title: value,
                    id: _editedGame.id,
                    isSelected: _editedGame.isSelected,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
