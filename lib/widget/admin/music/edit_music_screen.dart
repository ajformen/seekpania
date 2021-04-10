import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/models/selections/select_music.dart';
import 'package:challenge_seekpania/provider/selections/musics.dart';

class EditMusicScreen extends StatefulWidget {
  static const routeName = '/edit-music';

  @override
  _EditMusicScreenState createState() => _EditMusicScreenState();
}

class _EditMusicScreenState extends State<EditMusicScreen> {
  final _form = GlobalKey<FormState>();
  var _editedMusic = SelectMusic(id: null, title: '');
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
    if (_editedMusic.id != null) {
      await Provider.of<Musics>(context, listen: false).updateMusic(_editedMusic.id, _editedMusic);
    } else {
      try {
        await Provider.of<Musics>(context, listen: false).addMusic(_editedMusic);
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
      final musicId = ModalRoute.of(context).settings.arguments as String;
      if (musicId != null) {
        _editedMusic = Provider.of<Musics>(context, listen: false).findById(musicId);
        _initValues = {
          'title': _editedMusic.title,
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
        title: Text('Edit Music'),
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
                  _editedMusic = SelectMusic(
                    title: value,
                    id: _editedMusic.id,
                    isSelected: _editedMusic.isSelected,
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
