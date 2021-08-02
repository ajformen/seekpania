import 'package:challenge_seekpania/page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:provider/provider.dart';

import '../account.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  TextEditingController pinController = TextEditingController();
  late UserAccount currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');

  logout() async {
    print('SIGN OUT NA');
    await googleSignIn.signOut();

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
  }

  pinCheck() async {
    final user = FirebaseAuth.instance.currentUser;
    currentUser = UserAccount(id: user!.uid);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    print(currentUser.pin);
    try {
      if (int.parse(pinController.text) == currentUser.pin) {
        print('MATCH');
        final deactivate = Provider.of<UserAccount>(context, listen: false);
        deactivate.deactivateAccount(currentUser.id!);
        logout();
        showFlash(
            context: context,
            duration: const Duration(seconds: 2),
            builder: (context, controller) {
              return Flash.bar(
                controller: controller,
                backgroundColor: Colors.grey[850]!,
                child: FlashBar(
                  message: Text('Account Deactivated',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                ),
              );
            }
        );
      } else {
        print('NOT MATCH');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              'Incorrect PIN',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Ok',
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  pinController.text = '';
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
      print('ENTER 6-DIGIT PIN');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'Please enter your 6-Digit PIN',
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

  }

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        displayPin(),
        submit(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, top: 15.0),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  displayPin() {
    return Container(
      margin: const EdgeInsets.only(top: 100.0),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
          controller: pinController,
          textAlign: TextAlign.center,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter your 6-Digit PIN',
          ),
        ),
      ),
    );
  }

  submit() {
    return Container(
      padding: const EdgeInsets.only(top: 40.0, left: 130.0),
      child: InkWell(
        onTap: () {
          pinCheck();
        },
        child: Container(
          width: 100.0,
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
              'Enter',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: display(),
        ),
      ),
    );
  }
}
