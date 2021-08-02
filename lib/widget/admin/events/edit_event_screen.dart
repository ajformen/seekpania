import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/models/selections/select_live_event.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';

class EditEventScreen extends StatefulWidget {
  static const routeName = '/edit-event';

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _form = GlobalKey<FormState>();
  var _editedEvent = SelectLiveEvent(id: null, title: '');
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
    if (_editedEvent.id != null) {
      await Provider.of<LiveEvents>(context, listen: false).updateLiveEvent(_editedEvent.id!, _editedEvent);
    } else {
      try {
        await Provider.of<LiveEvents>(context, listen: false).addLiveEvent(_editedEvent);
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
      final eventId = ModalRoute.of(context)!.settings.arguments as String;
      if (eventId != null) {
        _editedEvent = Provider.of<LiveEvents>(context, listen: false).findById(eventId);
        _initValues = {
          'title': _editedEvent.title.toString(),
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
        title: Text('Edit Event'),
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
                  _editedEvent = SelectLiveEvent(
                    title: value,
                    id: _editedEvent.id,
                    isSelected: _editedEvent.isSelected,
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
