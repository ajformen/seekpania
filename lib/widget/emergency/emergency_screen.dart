import 'package:challenge_seekpania/models/selections/select_emergency.dart';
import 'package:challenge_seekpania/provider/emergencies.dart';
import 'package:challenge_seekpania/widget/emergency/view_emergency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EmergencyScreen extends StatefulWidget {
  final String? accountID;

  EmergencyScreen({this.accountID});
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  TextEditingController relationshipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var _editedEmergency;
  String emergencyID = Uuid().v4();

  Future<void> _submit() async {
    _editedEmergency = SelectEmergency(
      id: emergencyID,
      name: nameController.text,
      relationship: relationshipController.text,
      email: emailController.text,
    );

    await Provider.of<Emergencies>(context, listen: false)
        .addEmergency(_editedEmergency, widget.accountID!);

    emergencyID = Uuid().v4();

    nameController.text = '';
    relationshipController.text = '';
    emailController.text = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Successfully Added Emergency Contact.',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Ok',
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Emergency Contact')),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewEmergency()
                  )
              );
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 18.0, 15.0, 10.0),
                child: Text(
                  'View',
                )
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Text(
              'IN CASE YOU ARE IN DANGER',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 30.0, right: 20.0),
            child: Text(
              'Add a person you know that will receive your message immediately if you are in danger during meet up',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 40.0, right: 20.0),
              child: Form(
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name of your Contact",
                    labelStyle: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 20.0, right: 20.0),
              child: Form(
                child: TextFormField(
                  controller: relationshipController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Relationship",
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "ex: Friend, Mother, Father, etc",
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 20.0, right: 20.0),
              child: Form(
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email of your Contact",
                    labelStyle: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 40.0, right: 20.0),
            child: InkWell(
              onTap: () {
                _submit();
              },
              child: Container(
                width: 130.0,
                height: 40.0,
                decoration: new BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple[700]!,
                  ),
                  color: Colors.deepPurple[700],
                  // shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'Add Emergency Contact',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
