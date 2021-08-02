import 'package:flutter/material.dart';

class VirtualLinkScreen extends StatefulWidget {
  @override
  _VirtualLinkScreenState createState() => _VirtualLinkScreenState();
}

class _VirtualLinkScreenState extends State<VirtualLinkScreen> {
  String? link;

  TextEditingController locationController = TextEditingController();

  final _form = GlobalKey<FormState>();

  _submit() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print('SAVED');
    Navigator.pop(context, locationController.text);
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
              if (locationController.text.isNotEmpty) {
                locationController.text = '';
              }
              Navigator.pop(context, locationController.text);
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              size: 30.0,
              color: Colors.deepPurple[900],
            ),
          ),
          Text(
            'Add Invitation Link',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0
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
            keyboardType: TextInputType.multiline,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an invitation link.';
              }

              return null;
            },
            controller: locationController,
            onSaved: (value) {
              link = value;
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
