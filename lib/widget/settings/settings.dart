import 'package:challenge_seekpania/widget/settings/pin.dart';
import 'package:challenge_seekpania/widget/settings/pin_delete.dart';
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/page/home_page.dart';
import 'package:challenge_seekpania/page/header.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';

import '../account.dart';
import 'package:challenge_seekpania/widget/sign_up_widget.dart';

class SettingsScreen extends StatefulWidget {
  final String? accountID;

  SettingsScreen({this.accountID});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  UserAccount? currentUser;

  Widget buildLoading() => Center(child: CircularProgressIndicator());

  logout() async {
    print('SIGN OUT NA');
    await googleSignIn.signOut();

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
  }

  askPin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PinScreen()
        )
    );
  }

  askDeletePin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PinDeleteScreen()
        )
    );
  }

  deactivateUser() {
    final deactivate = Provider.of<UserAccount>(context, listen: false);
    deactivate.deactivateAccount(widget.accountID!);
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
  }

  deleteUser() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SignUpWidget()
        )
    );
    showFlash(
        context: context,
        duration: const Duration(seconds: 2),
        builder: (context, controller) {
          return Flash.bar(
            controller: controller,
            backgroundColor: Colors.grey[850]!,
            child: FlashBar(
              message: Text('Account deleted successfully',
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
          );
        }
    );
  }

  buildSettings() {
    return FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(widget.accountID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buildLoading();
          }
          currentUser = UserAccount.fromDocument(snapshot.data!);
          return Container(
            child: Column(
              children: [
                /// Deactivate an Account
                Container(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                            'Your account will be disabled and can\'t be seen to any activity searches. You can enable it by logging in.',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              onPressed: () {
                                askPin();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 130.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        border: Border.all(
                          color: Colors.amber[700]!,
                        ),
                        color: Colors.amber[700],
                        // shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'Deactivate Account',
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
                SizedBox(height: 30.0,),
                /// Delete an account
                Container(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                            'This will be permanent deletion of your account. You won\'t be able to retrieve any messages.',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              onPressed: () {
                                askDeletePin();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 130.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                        color: Colors.red,
                        // shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'Delete Account',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, titleText: "Settings"),
        body: ListView(
          children: <Widget>[buildSettings()],
        )
    );
  }
}
