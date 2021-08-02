import 'package:flash/flash.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/widget/check_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String? currentUserID, theCountry, thePhoto;

  EditProfile({this.currentUserID, this.theCountry, this.thePhoto});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? photoURL;
  String? firstName;
  String? lastName;
  String? fullName;
  CountryCode? country;
  String? gender;
  String? status;
  TextEditingController displayFullNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController genderCustomController = TextEditingController();
  bool isLoading = false;
  bool isVisible = false;
  late UserAccount user;

  bool isGenderVisible = false;
  bool isStatusVisible = false;
  bool isCountryVisible = false;
  bool isBirthDateVisible = false;

  bool _genderValid = true;
  bool _genderCustomValid = true;
  bool _statusValid = true;
  bool _countryValid = true;
  bool _cityValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserID).get();
    user = UserAccount.fromDocument(doc);
    setState(() {
      isLoading = true;
      gender = user.gender;
    });
    photoURL = widget.thePhoto;
    firstName = user.firstName;
    lastName = user.lastName;
    fullName = "$firstName $lastName";
    displayFullNameController.text = fullName!;
    cityController.text = user.city!;

    if (gender == "Non-Binary") {
      isVisible = true;
      genderCustomController.text = user.genderCustom!;
    } else {
      isVisible = false;
      gender = user.gender;
    }
    status = user.status;
  }

  validateProfileData() {

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

      cityController.text.trim().length < 3 || cityController.text.isEmpty ? _cityValid = false : _cityValid = true;
      genderCustomController.text.trim().length < 3 || genderCustomController.text.isEmpty ? _genderCustomValid = false : _genderCustomValid = true;
    });

    // if data inputs are valid it will update and route back to Profile Page
    if (_genderValid && _statusValid && _countryValid && _cityValid) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to update your profile?'),
            actions: [
              FlatButton(
                child: Text('Yes'),
                onPressed: () => updateProfileData(),
              )
            ],
          )
      );
    }
  }

  updateProfileData() {
    usersRef.doc(widget.currentUserID).update({
      "email": user.email,
      "photoUrl": photoURL,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "gender": gender,
      "genderCustom": genderCustomController.text,
      "status": status,
      "city": cityController.text,
      // "country": country.name,
      "country": country!.name,
      "countryDialCode": country!.dialCode,
      "birthDate": user.birthDate,
      "age": user.age,
    });

    showFlash(
      context: context,
      duration: const Duration(seconds: 4),
      builder: (context, controller) {
        return Flash.bar(
          controller: controller,
          backgroundColor: Colors.grey[850]!,
          child: FlashBar(
            message: Text('Profile has been updated',
            style: TextStyle(
              color: Colors.white,
            ),),
          ),
        );
      }
    );

    print('Profile has been updated!');
    Navigator.of(context).pop();
  }

  void dispose() {
    super.dispose();
    print('DISPOSE EDIT PROFILE');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Edit Profile",
            style: TextStyle(
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green[100],
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 5.0),
            child: Container(
              child: Form(
                child: TextFormField(
                  enabled: false,
                  controller: displayFullNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "My name",
                    labelStyle: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 5.0),
            child: Text(
              'Lives in',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0),
            child: Container(
              child: Form(
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "ex: New York City",
                    errorText: _cityValid ? null : "City is too short",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 5.0),
            child: Text(
              'Country',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 5.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  child: CountryListPick(
                    // initialSelection: 'PILI NA UY',
                    initialSelection: widget.theCountry,
                    onChanged: (CountryCode? name) {
                      setState(() {
                        country = name;
                        print(country!.name);
                        isCountryVisible = false;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Visibility(
                  visible: isCountryVisible,
                  maintainSize: false,
                  maintainAnimation: false,
                  maintainState: false,
                  child: Center(
                    child: Text(
                      'For validation purposes, select your country again',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 5.0),
            child: Text(
              'Gender',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
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
            padding: EdgeInsets.fromLTRB(0, 0, 150.0, 0),
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
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 5.0),
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0 ),
              child: DropdownButton(
                hint: Text('Status'),
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
            padding: EdgeInsets.only(right: 150.0),
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
            padding: EdgeInsets.only(top: 15.0),
            child: RaisedButton(
              onPressed: validateProfileData,
              child: Text(
                "Update Profile",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
