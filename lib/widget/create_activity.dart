import 'dart:async';
import 'package:challenge_seekpania/widget/health_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/virtual/virtual_activity_interest_screen.dart';

class CreateActivity extends StatefulWidget {

  @override
  _CreateActivityState createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {

  String? location;
  final user = FirebaseAuth.instance.currentUser;
  Position? _position;
  late StreamSubscription<Position> _streamSubscription;
  Address? _address;

  @override
  void initState() {
    super.initState();
    var lastPosition = Geolocator.getLastKnownPosition();
    print('LAST POSITION');
    print(lastPosition);
    _streamSubscription = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, distanceFilter: 10).listen((Position position) {
      setState(() {
        print(position);
        _position = position;

        final coordinates = new Coordinates(position.latitude, position.longitude);
        // convertCoordinatesToAddress(coordinates).then((value) => _address = value);
        convertCoordinatesToAddress(coordinates);
      });
    });
  }

  _checkUserHealth() async {
    final user = FirebaseAuth.instance.currentUser;
    final usersRef = FirebaseFirestore.instance.collection('users');
    UserAccount currentUser;
    currentUser = UserAccount(id: user!.uid);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    print('USERS STATUS NOW!!!!');
    print(currentUser.userStatus);
    if (currentUser.health == 'NOT SAFE') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'Due to your health issues. You have been restricted from using the app.',
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
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HealthFormScreen()
          )
      );
    }
  }

  void dispose() {
    super.dispose();
    print('DISPOSE TIMELINE');
    _streamSubscription.cancel();
  }

  //adminArea = Central Visayas
  //subAdminArea = Cebu
  //locality = Cebu City
  Future<void> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addressess = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      location = addressess.first.subAdminArea;
      print(location);
    });
    updateUserCurrentLocation();
  }

  updateUserCurrentLocation() async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');
      UserAccount currentUser;
      currentUser = UserAccount(id: user!.uid);
      await usersRef.doc(currentUser.id).update({
        'currentLocation': location,
      });
      print('CURRENT USER UPDATED');

    } catch (error) {
      print(error);
    }
  }

  viewFaceToFace() {
    _checkUserHealth();
  }

  viewVirtualGathering() {
    Navigator.of(context).pushNamed(VirtualActivityInterestScreen.routeName);
  }

  buildFaceToFace() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // 'Meet your companion personally within your area!',
            'What am I going to do today?',
            style: TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          // SizedBox(height: 10,),
        ],
      ),
    );
  }

  buildVirtualGathering() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // 'Have a virtual experience with your companion!',
            'Who am I going to do it with?',
            style: TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 130.0,
            child: RaisedButton(
              onPressed: buildCreateScreen,
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),
              child: Text(
                'CREATE ACTIVITY',
                style: TextStyle(
                  fontSize: 8.0,
                  // color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildHomeScreen() {
    return Container(
      width: 360.0,
      height: 654.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildFaceToFace(),
          SizedBox(height: 15,),
          buildVirtualGathering(),
        ],
      ),
    );
  }

  void buildCreateScreen() => showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      )
    ),
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.0,),
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0,),
        ListTile(
          leading: Icon(
            Icons.accessibility_new,
            color: Colors.deepPurple[900],
          ),
          title: Text(
            'Face to Face',
          ),
          onTap: () => {
            Navigator.of(context).pop(context),
            viewFaceToFace()
          }
        ),
        SizedBox(height: 10.0,),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildHomeScreen(),
          ],
        ),
      ),
    );
  }
}
