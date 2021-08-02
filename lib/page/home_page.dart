import 'package:challenge_seekpania/models/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/provider/google_sign_in.dart';
import 'package:challenge_seekpania/widget/sign_up_widget.dart';
import 'package:challenge_seekpania/widget/check_user.dart';
import 'package:provider/provider.dart';

UserAccount? currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            this._user = snapshot.data as User?;
            currentUser = UserAccount(id: _user!.uid);
            print('HOME PAGE USER ID:');
            print(currentUser!.id);
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