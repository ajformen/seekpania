import 'dart:async';
import 'package:challenge_seekpania/models/selections/select_emergency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmergencyItems extends StatefulWidget {
  final SelectEmergency? info;
  final String? lat;
  final String? long;
  final String? location;

  EmergencyItems({this.info, this.lat, this.long, this.location});

  @override
  _EmergencyItemsState createState() => _EmergencyItemsState();
}

class _EmergencyItemsState extends State<EmergencyItems> {
  int id = 0;
  String? invStatus;
  UserAccount? currentUser;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    print('CHAPERONE ID');
    print(widget.info!.id);
    super.initState();
  }

  void refreshData() {
    id++;
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(
              widget.info!.name!.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              widget.info!.name!,
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              widget.info!.relationship!,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          onTap: () async {
            print(widget.info!.id!);
            print(widget.info!.email!);
            print(widget.lat);
            print(widget.long);
            print(widget.location);
            /// Send email notifications to the user that his/her account is deleted
            String username = 'dev.seekpania@gmail.com';
            String password = 'Seekpania654';

            final smtpServer = gmail(username, password);

            /// Create our email message
            final message = Message()..from = Address(username, 'Seekpania')..recipients.add(widget.info!.email!)
              ..subject = 'DANGER : ${DateTime.now()}'
              ..html = "<h3>Your ${widget.info!.relationship!} is now in danger and needs help.</h3>\n"
                  "<p>Coordinates</p>\n""<p>Latitude: ${widget.lat} - Longitude: ${widget.long}</p>\n"
                  "<p>Location: ${widget.location}</p>";

            try {
              final sendEmail = await send(message, smtpServer);
              print(sendEmail.toString());
            } on MailerException catch (e) {
              print('Message not sent. \n' + e.toString());
            }

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                // title: Text('Are you sure?'),
                content: Text(
                  'Emergency message has been sent to your ${widget.info!.relationship!}.',
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
          },
        ),
        SizedBox(height: 10.0,),
        // Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}
