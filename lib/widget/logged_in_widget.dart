import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:challenge_seekpania/widget/sign_up_widget.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoggedInWidget extends StatefulWidget {

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  late UserAccount currentUser;
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    DocumentSnapshot doc = await usersRef.doc(user!.uid).get();
    currentUser = UserAccount.fromDocument(doc);
  }

  logout() async {
    print('SIGN OUT NA');
    await googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.deepPurple,
      title: Text('Profile'),
      centerTitle: true,
      elevation: 0,
    ),
    body: Container(
      // alignment: Alignment.center,
      // color: Colors.blueGrey.shade900,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Logged In',
            //   style: TextStyle(color: Colors.black),
            // ),
            SizedBox(height: 8),
            CircleAvatar(
              maxRadius: 35,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            SizedBox(height: 8),
            Text(
              user!.displayName!,
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8),
            Text(
              '24, Male, Single',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cebu City',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'More about me',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Country',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Philippines',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Currently living in',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cebu City',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'I am',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Single',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Gender',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Male',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Birthday',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'May 10, 1996',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Email',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 8),
            Text(
              user!.email!,
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // final provider =
                // Provider.of<GoogleSignInProvider>(context, listen: false);
                // provider.logout();
                logout();
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
    ),
    );
  }
}