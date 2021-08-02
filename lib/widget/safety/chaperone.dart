import 'package:challenge_seekpania/models/selections/select_chaperone.dart';
import 'package:challenge_seekpania/provider/selections/chaperones.dart';
import 'package:challenge_seekpania/widget/safety/view_chaperone.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChaperoneScreen extends StatefulWidget {
  final String? accountID;

  ChaperoneScreen({this.accountID});
  @override
  _ChaperoneScreenState createState() => _ChaperoneScreenState();
}

class _ChaperoneScreenState extends State<ChaperoneScreen> {
  TextEditingController relationshipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var _editedChaperone;
  String chaperoneID = Uuid().v4();

  Future<void> _submit() async {
    _editedChaperone = SelectChaperone(
      id: chaperoneID,
      name: nameController.text,
      relationship: relationshipController.text,
    );

    await Provider.of<Chaperones>(context, listen: false)
        .addChaperone(_editedChaperone, widget.accountID!);

    chaperoneID = Uuid().v4();

    nameController.text = '';
    relationshipController.text = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Successfully Added Chaperone.',
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
        title: Center(child: Text('Chaperone')),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewChaperone()
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Text(
              'WE CARE ABOUT YOUR SAFETY',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16.0
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 30.0, right: 20.0),
            child: Text(
              'Add a person you trusts that will accompany and looks after you during face-to-face meet-up',
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
                    labelText: "Name of your Chaperone",
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
                    'Add Your Chaperone',
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
