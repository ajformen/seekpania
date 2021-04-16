import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/widget/check_user.dart';
import 'package:challenge_seekpania/widget/notifications.dart';
import 'package:challenge_seekpania/widget/account.dart';
import 'package:challenge_seekpania/widget/create_activity.dart';
import 'package:challenge_seekpania/widget/home/home_screen.dart';
import 'package:challenge_seekpania/widget/messages/messaging.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class Timeline extends StatefulWidget {
  // final String timelineID;
  //
  // Timeline({ this.timelineID });
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  // final currentUser = usersRef.doc(user.uid).get();

  final user = FirebaseAuth.instance.currentUser;

  // String location;
  // Position _position;
  // StreamSubscription<Position> _streamSubscription;
  // Address _address;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  //   _streamSubscription = Geolocator().getPositionStream(locationOptions).listen((Position position) {
  //     setState(() {
  //       print(position);
  //       _position = position;
  //
  //       final coordinates = new Coordinates(position.latitude, position.longitude);
  //       // convertCoordinatesToAddress(coordinates).then((value) => _address = value);
  //       convertCoordinatesToAddress(coordinates);
  //     });
  //   });
  //
  //   // getCurrentLocation();
  //   updateUserCurrentLocation();
  // }
  //
  // void dispose() {
  //   super.dispose();
  //   print('DISPOSE TIMELINE');
  //   _streamSubscription.cancel();
  // }
  //
  // //adminArea = Central Visayas
  // //subAdminArea = Cebu
  // //locality = Cebu City
  // convertCoordinatesToAddress(Coordinates coordinates) async {
  //   var addressess = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   setState(() {
  //     location = addressess.first.subAdminArea;
  //     print(location);
  //   });
  // }
  //
  // updateUserCurrentLocation() async{
  //   try {
  //     final usersRef = FirebaseFirestore.instance.collection('users');
  //     UserAccount currentUser;
  //     currentUser = UserAccount(id: user.uid);
  //     await usersRef.doc(currentUser.id).update({
  //       'currentLocation': location,
  //     });
  //     print('CURRENT USER UPDATED');
  //
  //   } catch (error) {
  //     print(error);
  //   }
  // }


  // Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
  //   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   return addresses.first;
  // }

  // getCurrentLocation() {
  //   var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  //   _streamSubscription = Geolocator().getPositionStream(locationOptions).listen((Position position) {
  //     setState(() {
  //       print(position);
  //       _position = position;
  //
  //       final coordinates = new Coordinates(position.latitude, position.longitude);
  //       convertCoordinatesToAddress(coordinates).then((value) => _address = value);
  //     });
  //   });
  // }

  // void getCurrentLocation() async {
  //   var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
  //   setState(() {
  //     _position = position;
  //
  //     final coordinates = new Coordinates(position.latitude, position.longitude);
  //     convertCoordinatesToAddress(coordinates).then((value) => _address = value);
  //   });
  // }

  int _selectedIndex = 0;

  // List<Widget> _widgetOptions = [Notifications(), Account(accountID: currentUser?.id)];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      // CustomPaint(painter: BackgroundPainter()),
      Center(child: CircularProgressIndicator()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(user!.uid).get(),
      //   future: usersRef.doc(widget.timelineID).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoading();
        }
        UserAccount currentUser = UserAccount.fromDocument(snapshot.data!);
        print('TIMELINE CURRENT USER ID: ');
        print(currentUser.id);
        print(currentUser.firstName);

        // print('LOCATION LATITUDE');
        // print({_position?.latitude?? '-'});
        // print('LOCATION LONGITUDE');
        // print({_position?.longitude?? '-'});
        // print('YOUR CURRENT LOCATION');
        // print(location);

        List<Widget> _widgetOptions = [CreateActivity(), Notifications(), Messaging(), Account(accountID: currentUser.id)];
        return Scaffold(
          body: PageView(
            children: <Widget>[
              _widgetOptions.elementAt(_selectedIndex),
            ],
          ),
          bottomNavigationBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.notifications
                ),
                label: 'Notifications',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(
              //     Icons.add_circle_outline_outlined,
              //     size: 45.0,
              //   ),
              //   // label: 'Create',
              // ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                ),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
          ),
        );
      }
    );
  }

}
