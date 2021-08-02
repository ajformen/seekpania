import 'dart:async';
import 'package:challenge_seekpania/provider/emergencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/widget/emergency/emergency_items.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class ViewEmergency extends StatefulWidget {
  @override
  _ViewEmergencyState createState() => _ViewEmergencyState();
}

class _ViewEmergencyState extends State<ViewEmergency> {

  final user = FirebaseAuth.instance.currentUser;

  var _isInit = true;
  var _isLoading = false;
  int id = 0;

  String? location;
  String? long;
  String? lat;
  Position? _position;
  late StreamSubscription<Position> _streamSubscription;
  // Address? _address;

  @override
  void initState() {
    super.initState();
    // var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    // below _streamSubscription was before the upgrade
    // _streamSubscription = Geolocator.getPositionStream(locationOptions).listen((Position position) {
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

  Future<void> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addressess = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      location = addressess.first.addressLine;
      print(location);
      lat = '${_position?.latitude}';
      print('LAT: ${lat!}');
      long = '${_position?.longitude}';
      print('LONG: ${long!}');
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Emergencies>(context).fetchEmergencies(user!.uid).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        viewEmergencies(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
      child: Text(
        'Emergency Contacts',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          // color: Color(0xff4e4b6f),
        ),
      ),
    );
  }

  noEmergencies() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 250.0),
      child: Column(
        children: [
          Text(
            'You don\'t have any emergency contacts.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  viewEmergencies() {
    final emergencies = Provider.of<Emergencies>(context, listen: false).emergencyLists.map((info) => EmergencyItems(info: info, lat: lat, long: long, location: location,)).toList();

    return Expanded(
      child: emergencies.length == 0 ? noEmergencies() : ListView(
        shrinkWrap: true,
        children: emergencies,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading ? Center(child: CircularProgressIndicator(),) : Container(
          child: display(),
        ),
      ),
    );
  }
}
