import 'package:challenge_seekpania/models/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:challenge_seekpania/widget/create_account.dart';
import 'package:challenge_seekpania/provider/google_sign_in.dart';
// import 'package:challenge_seekpania/widget/background_painter.dart';
import 'package:challenge_seekpania/widget/logged_in_widget.dart';
import 'package:challenge_seekpania/widget/sign_up_widget.dart';
import 'package:challenge_seekpania/widget/check_user.dart';
import 'package:provider/provider.dart';

// final user = FirebaseAuth.instance.currentUser;
UserAccount currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // setState(() {
    //   this._user = FirebaseAuth.instance.currentUser;
    // });
  }

  @override
  void dispose() {
    super.dispose();
    print('DISPOSE HOME PAGE');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context);

          if (provider.isSigningIn) {
            return buildLoading();
          } else if (snapshot.hasData) {
            print(snapshot.data);
            this._user = snapshot.data;
            currentUser = UserAccount(id: _user.uid);
            // currentUser.id = "";
            print('HOME PAGE USER ID:');
            print(currentUser.id);
            // print('TOKEN');
            return CheckUser();
          } else {
            return SignUpWidget();
          }
        },
      ),
    ),
  );

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      // CustomPaint(painter: BackgroundPainter()),
      Center(child: CircularProgressIndicator()),
    ],
  );
}