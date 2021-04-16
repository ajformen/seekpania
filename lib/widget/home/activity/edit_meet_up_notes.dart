import 'package:flutter/material.dart';

class EditMeetUpNotes extends StatefulWidget {
  @override
  _EditMeetUpNotesState createState() => _EditMeetUpNotesState();
}

class _EditMeetUpNotesState extends State<EditMeetUpNotes> {
  late String notes;

  TextEditingController notesController = TextEditingController();

  final _form = GlobalKey<FormState>();

  _submit() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print('SAVED');
    Navigator.pop(context, notesController.text);
  }

  display() {
    return Column(
      children: [
        header(),
        editNotes(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (notesController.text.isNotEmpty) {
                notesController.text = '';
              }
              Navigator.pop(context, notesController.text);
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              size: 30.0,
              color: Colors.deepPurple[900],
            ),
          ),
          Text(
            'Meet-up Notes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
            ),
          ),
          GestureDetector(
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.deepPurple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _submit();
            },
          ),
        ],
      ),
    );
  }

  editNotes() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Form(
        key: _form,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Notes for your companion on how to find you.',
            hintStyle: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14.0
            ),
          ),
          maxLines: 13,
          keyboardType: TextInputType.multiline,
          // focusNode: _editNotesFocusNode,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter location.';
            }

            return null;
          },
          controller: notesController,
          onSaved: (value) {
            notes = value!;
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: display(),
          ),
        ),
      ),
    );
  }
}
