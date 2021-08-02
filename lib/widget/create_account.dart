import 'package:flash/flash.dart';
import 'package:challenge_seekpania/widget/timeline.dart';
import 'package:intl/intl.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/page/header.dart';
import 'package:challenge_seekpania/widget/check_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

final DateTime timestamp = DateTime.now();
late UserAccount currentUser;

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController genderCustomController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int ? pin;
  String? email;
  String? gender;
  String? genderCustom;
  String? status;
  CountryCode? country;
  String? city;
  DateTime? birthDate;
  String? formatBirthDate;
  int? age;

  bool isVisible = false;

  bool isGenderVisible = false;
  bool isStatusVisible = false;
  bool isCountryVisible = false;
  bool isBirthDateVisible = false;

  bool _pinValid = true;
  bool _genderValid = true;
  bool _genderCustomValid = true;
  bool _statusValid = true;
  bool _countryValid = true;
  bool _cityValid = true;
  bool _birthDateValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    print('DISPOSE CREATE ACCOUNT');
  }

  submit() {
    setState(() {
      if (gender == null) {
        _genderValid = false;
        isGenderVisible = true;
      } else {
        _genderValid = true;
      }

      if (status == null) {
        _statusValid = false;
        isStatusVisible = true;
      } else {
        _statusValid = true;
      }

      if (country == null) {
        _countryValid = false;
        isCountryVisible = true;
      } else {
        _countryValid = true;
      }

      pinController.text.trim().length < 3 || pinController.text.isEmpty ? _pinValid = false : _pinValid = true;
      cityController.text.trim().length < 3 || cityController.text.isEmpty ? _cityValid = false : _cityValid = true;
      genderCustomController.text.trim().length < 3 || genderCustomController.text.isEmpty ? _genderCustomValid = false : _genderCustomValid = true;

      if (birthDate == null) {
        _birthDateValid = false;
        isBirthDateVisible = true;
      } else {
        _birthDateValid = true;
      }
    });

    // if data inputs are valid it will save and route to the Timeline Page
    if (_genderValid && _statusValid && _countryValid && _cityValid && _birthDateValid) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Some data will not be edited. Do you want to continue?'),
            actions: [
              FlatButton(
                child: Text('Yes'),
                onPressed: () => createProfileData(),
              )
            ],
          )
      );
    }
  }

  createProfileData() async {
    _formKey.currentState!.save();
    currentUser = UserAccount(id: user!.uid);
    DocumentSnapshot doc = await usersRef.doc(currentUser.id).get();
    /// for mobile users
    usersRef.doc(currentUser.id).set({
      "id": currentUser.id,
      "email": email,
      "photoURL": user!.photoURL,
      "firstName": user!.displayName!.split(" ")[0],
      "lastName": user!.displayName!.split(" ")[1],
      "pin": int.parse(pinController.text),
      "gender": gender,
      "genderCustom": genderCustomController.text,
      "status": status,
      "city": cityController.text,
      "country": country!.name,
      "countryDialCode": country!.dialCode,
      "birthDate": formatBirthDate,
      "age": age,
      "userStatus": 'Active',
      "timestamp": timestamp,
      "currentLocation": '',
      "points": 30.0,
      "health": '',
      "chats": [],
    });
    doc = await usersRef.doc(currentUser.id).get();
    currentUser = UserAccount.fromDocument(doc);
    print(currentUser);
    print(currentUser.email);
    print(currentUser.city);
    print(currentUser.country);

    /// send this to the server
    final usersDbRef = FirebaseFirestore.instance.collection('usersDB');
    usersDbRef.doc(currentUser.id).set({
      "id": currentUser.id,
      "email": email,
      "photoURL": user!.photoURL,
      "firstName": user!.displayName!.split(" ")[0],
      "lastName": user!.displayName!.split(" ")[1],
      "pin": int.parse(pinController.text),
      "gender": gender,
      "genderCustom": genderCustomController.text,
      "status": status,
      "city": cityController.text,
      "country": country!.name,
      "countryDialCode": country!.dialCode,
      "birthDate": formatBirthDate,
      "age": age,
      "userStatus": 'Active',
      "timestamp": timestamp,
      "currentLocation": '',
      "points": 30.0,
      "health": '',
      "chats": [],
    });

    /// Send email notifications to the user that his/her account is deleted
    String username = 'dev.seekpania@gmail.com';
    String password = 'Seekpania654';

    final smtpServer = gmail(username, password);

    /// Create our email message
    final message = Message()..from = Address(username, 'Seekpania')..recipients.add(currentUser.email)
      ..subject = 'Account Registration : ${DateTime.now()}'
      ..html = "<h3>Thank you for registering with us! Happy seeking!</h3>\n<p></p>";

    try {
      final sendEmail = await send(message, smtpServer);
      print(sendEmail.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }

    showFlash(
        context: context,
        duration: const Duration(seconds: 1),
        builder: (context, controller) {
          return Flash.bar(
            controller: controller,
            backgroundColor: Colors.grey[850]!,
            child: FlashBar(
              message: Text('Account created successfully',
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
          );
        }
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Timeline()));
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context,
        titleText: 'Set up your profile',
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 5.0),
                  child: Container(
                    child: Form(
                      child: TextFormField(
                        enabled: false,
                        initialValue: user!.displayName!.split(" ")[0],
                        onSaved: (val) => city = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "First Name",
                          labelStyle: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                  child: Container(
                    child: Form(
                      child: TextFormField(
                        enabled: false,
                        initialValue: user!.displayName!.split(" ")[1],
                        onSaved: (val) => city = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Last Name",
                          labelStyle: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0),
                  child: Container(
                    child: Form(
                      child: TextFormField(
                        onSaved: (val) => city = val,
                        controller: pinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "6-Digit PIN",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Enter 6-Digit PIN",
                          errorText: _pinValid ? null : "PIN is too short",
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 200.0, 0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isGenderVisible,
                        maintainSize: false,
                        maintainAnimation: false,
                        maintainState: false,
                        child: Text(
                          'Select your gender',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: "Male",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                            isVisible = false;
                            isGenderVisible = false;
                          });
                        },
                      ),
                      Text(
                        'Male',
                      ),
                      Radio(
                        value: "Female",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                            isVisible = false;
                            isGenderVisible = false;
                          });
                        },
                      ),
                      Text(
                        'Female',
                      ),
                      Radio(
                        value: "Non-Binary",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                            isVisible = true;
                            isGenderVisible = false;
                          });
                        },
                      ),
                      Text(
                        'Non-binary',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isVisible,
                        maintainSize: false,
                        maintainAnimation: false,
                        maintainState: false,
                        child: Form(
                          child: TextFormField(
                            onSaved: (val) => city = val,
                            controller: genderCustomController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Gender",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Lesbian/Gay/Transgender/etc",
                              errorText: _genderCustomValid ? null : "Gender is too short",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 200.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isStatusVisible,
                        maintainSize: false,
                        maintainAnimation: false,
                        maintainState: false,
                        child: Text(
                          'Select your status',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0 ),
                  child: DropdownButton(
                    hint: Text('Select your status'),
                    isExpanded: true,
                    value: status,
                    items: [
                      DropdownMenuItem(
                          child: Text("Single"),
                          value: "Single",
                      ),
                      DropdownMenuItem(
                          child: Text("In a relationship"),
                          value: "In a relationship",
                      ),
                      DropdownMenuItem(
                        child: Text("Married"),
                        value: "Married",
                      ),
                      DropdownMenuItem(
                        child: Text("Single Parent"),
                        value: "Single Parent",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        status = value.toString();
                        isStatusVisible = false;
                      });
                    },
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 200.0, 0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isCountryVisible,
                        maintainSize: false,
                        maintainAnimation: false,
                        maintainState: false,
                        child: Text(
                          'Select your country',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 5.0),
                  // alignment: Alignment.center,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: CountryListPick(
                          // initialSelection: null,
                          onChanged: (CountryCode? name) {
                            setState(() {
                              country = name;
                              print(country!.name);
                              print(country!.dialCode);
                              isCountryVisible = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0),
                  child: Container(
                    child: Form(
                      child: TextFormField(
                        onSaved: (val) => city = val,
                        controller: cityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "City",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "ex: New York City",
                          errorText: _cityValid ? null : "City is too short",
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        child: Text((birthDate == null ? 'Select your birth date' : formatBirthDate)!),
                        color: Colors.white,
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: birthDate == null ? DateTime.now() : birthDate!,
                            firstDate: DateTime(1920),
                            lastDate: DateTime(2300)
                          ).then((date) {
                            setState(() {
                              birthDate = date;
                              formatBirthDate = DateFormat('MMMM-dd-yyyy').format(birthDate!);
                              age = timestamp.year - birthDate!.year;
                              print('AGE');
                              print(age);
                              isBirthDateVisible = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 175.0, 10.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isBirthDateVisible,
                        maintainSize: false,
                        maintainAnimation: false,
                        maintainState: false,
                        child: Text(
                          'Select your birth date',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        enabled: false,
                        initialValue: user!.email,
                        onSaved: (val) => email = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: GestureDetector(
                    onTap: submit,
                    child: Container(
                      height: 50.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
