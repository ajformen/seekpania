import 'package:challenge_seekpania/models/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/interests/activity_interest_screen.dart';

class HealthFormScreen extends StatefulWidget {
  @override
  _HealthFormScreenState createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen> {
  String? answer1, answer2, answer3;

  submit() {
    final user = FirebaseAuth.instance.currentUser;
    final check = Provider.of<UserAccount>(context, listen: false);
    if (answer1 == 'Yes' || answer2 == 'Yes' || answer3 == 'Yes') {
      print('OPPPSSS');
      check.checkHealth(user!.uid);
      Navigator.of(context).pop();
    } else {
      print('YES');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ActivityInterestScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Declaration Form',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
            child: Text(
              '1. Have you or anyone you immediately know had a confirmed case of COVID-19?'
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(80.0, 10.0, 0, 0),
            child: Row(
              children: <Widget>[
                Radio(
                  value: "Yes",
                  groupValue: answer1,
                  onChanged: (value) {
                    setState(() {
                      answer1 = value.toString();
                    });
                  },
                ),
                Text(
                  'Yes',
                ),
                Radio(
                  value: "No",
                  groupValue: answer1,
                  onChanged: (value) {
                    setState(() {
                      answer1 = value.toString();
                    });
                  },
                ),
                Text(
                  'No',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Text(
                '2. Do you or anyone you know currently have any of the symptoms associated with COVID-19 or similar?'
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(80.0, 10.0, 0, 0),
            child: Row(
              children: <Widget>[
                Radio(
                  value: "Yes",
                  groupValue: answer2,
                  onChanged: (value) {
                    setState(() {
                      answer2 = value.toString();
                    });
                  },
                ),
                Text(
                  'Yes',
                ),
                Radio(
                  value: "No",
                  groupValue: answer2,
                  onChanged: (value) {
                    setState(() {
                      answer2 = value.toString();
                    });
                  },
                ),
                Text(
                  'No',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Text(
                '3. Have you been tested for the COVID-19 virus?'
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(80.0, 10.0, 0, 0),
            child: Row(
              children: <Widget>[
                Radio(
                  value: "Yes",
                  groupValue: answer3,
                  onChanged: (value) {
                    setState(() {
                      answer3 = value.toString();
                    });
                  },
                ),
                Text(
                  'Yes',
                ),
                Radio(
                  value: "No",
                  groupValue: answer3,
                  onChanged: (value) {
                    setState(() {
                      answer3 = value.toString();
                    });
                  },
                ),
                Text(
                  'No',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 40.0, left: 15.0, right: 10.0, bottom: 20.0),
            child: Text(
              'By signing this form I declare all information is true and correct at the time of signing',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
          Container(
            child: InkWell(
              onTap: () {
                submit();
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
                    'Agree & Submit',
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
