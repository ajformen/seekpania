import 'package:challenge_seekpania/page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../account.dart';

class PinDeleteScreen extends StatefulWidget {
  @override
  _PinDeleteScreenState createState() => _PinDeleteScreenState();
}

class _PinDeleteScreenState extends State<PinDeleteScreen> {
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
        final delete = Provider.of<UserAccount>(context, listen: false);
        delete.deleteAccount(currentUser.id!, currentUser.firstName!, currentUser.photoURL!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SignUpWidget()
            )
        );

        /// Send email notifications to the user that his/her account is deleted
        String username = 'dev.seekpania@gmail.com';
        String password = 'Seekpania654';

        final smtpServer = gmail(username, password);

        /// Create our email message
        final message = Message()..from = Address(username, 'Seekpania')..recipients.add(currentUser.email)
        ..subject = 'Account Deletion : ${DateTime.now()}'
        ..html = "<h3>Your Account has been deleted! Thank you for connecting with us!</h3>\n<p></p>";

        try {
          final sendEmail = await send(message, smtpServer);
          print(sendEmail.toString());
        } on MailerException catch (e) {
          print('Message not sent. \n' + e.toString());
        }

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
