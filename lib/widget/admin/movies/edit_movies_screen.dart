import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/models/selections/select_movies.dart';
import 'package:challenge_seekpania/provider/selections/movies.dart';

class EditMoviesScreen extends StatefulWidget {
  static const routeName = '/edit-movies';

  @override
  _EditMoviesScreenState createState() => _EditMoviesScreenState();
}

class _EditMoviesScreenState extends State<EditMoviesScreen> {
  final _form = GlobalKey<FormState>();
  var _editedMovies = SelectMovies(id: null, title: '');
  var _initValues = {
    'title': '',
  };
  var _isInit = true;
  var _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedMovies.id != null) {
      await Provider.of<Movies>(context, listen: false).updateMovies(_editedMovies.id, _editedMovies);
    } else {
      try {
        await Provider.of<Movies>(context, listen: false).addMovies(_editedMovies);
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
      final movieId = ModalRoute.of(context).settings.arguments as String;
      if (movieId != null) {
        _editedMovies = Provider.of<Movies>(context, listen: false).findById(movieId);
        _initValues = {
          'title': _editedMovies.title,
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
        title: Text('Edit Movies'),
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
                  if (value.isEmpty) {
                    return 'Please provide the name of the game.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedMovies = SelectMovies(
                    title: value,
                    id: _editedMovies.id,
                    isSelected: _editedMovies.isSelected,
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
