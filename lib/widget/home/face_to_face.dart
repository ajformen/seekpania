import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/invitations.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/home/interests/activity_search.dart';
import 'package:challenge_seekpania/widget/home/activity/set_date_time.dart';
import 'package:challenge_seekpania/widget/home/activity/edit_meet_up_notes.dart';
import 'package:challenge_seekpania/widget/home/activity/set_location.dart';

class FaceToFace extends StatefulWidget {
  // static const routeName = './activity-face-to-face';

  final String? interestID;
  final String? interest;
  final String? type;

  FaceToFace({this.interestID, this.interest, this.type});

  @override
  _FaceToFaceState createState() => _FaceToFaceState();
}

class _FaceToFaceState extends State<FaceToFace> {
  String activityID = Uuid().v4();
  var _editedActivity;

  TextEditingController captionController = TextEditingController();
  TextEditingController participantsController = TextEditingController();
  final _captionForm = GlobalKey<FormState>();
  final _howManyForm = GlobalKey<FormState>();
  // var _editedInvite = SelectInvite(id: null, caption: '', participants: '');
  String? caption, participants;

  bool isOneSelected = false;
  bool isGroupSelected = false;
  bool isHowMany = true;
  bool isCompanionSelected = false;
  bool isInvalidGroupInput = false;
  bool isInvalidOneInput = false;
  bool isSchedule = false;
  bool isNotes = true;
  bool isLocation = true;
  bool isInvalidLocation = false;

  String? notes;
  String? location;

  String? _setTime, _setDate;
  String? _hour, _minute, _time;
  String? dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101)
    ))!;
    if (picked != null)
      setState(() {
        selectedDate = picked;
        // _dateController.text = DateFormat.yMd().format(selectedDate);
        _dateController.text = DateFormat('MMMM-dd-yyyy').format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedTime,
    ))!;
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController.text = _time!;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, "" "", am]
        ).toString();
      });
  }

  @override
  void initState() {
    // _dateController.text = DateFormat.yMd().format(DateTime.now());
    _dateController.text = DateFormat('MMMM-dd-yyyy').format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    super.initState();
  }

  Future<void> _submit() async {
    final isCaptionValid = _captionForm.currentState!.validate();
    final isHowManyValid = _howManyForm.currentState!.validate();
    if (isOneSelected == false && isGroupSelected == false && participantsController.text.isNotEmpty) {
      setState(() {
        isCompanionSelected = true;
      });
      return;
    }

    if(isGroupSelected == true && participantsController.text == '1') {
      // return Text('Invalid', style: TextStyle(fontSize: 8.0, color: Theme.of(context).errorColor),);
      setState(() {
        isInvalidGroupInput = true;
      });
      return;
    }

    if(isOneSelected == true && participantsController.text != '1') {
      // return Text('Invalid', style: TextStyle(fontSize: 8.0, color: Theme.of(context).errorColor),);
      setState(() {
        isInvalidOneInput = true;
      });
      return;
    }

    if (!isCaptionValid || !isHowManyValid) {
      return;
    }

    // if (scheduleType == 'set a schedule') {
    //   setState(() {
    //     isSchedule = true;
    //   });
    //   return;
    // }

    if (location == null) {
      setState(() {
        isInvalidLocation = true;
      });
      return;
    }

    _captionForm.currentState!.save();
    _howManyForm.currentState!.save();

    setState(() {
      isOneSelected = false;
      isGroupSelected = false;
      isCompanionSelected = false;
      isInvalidGroupInput = false;
      isInvalidOneInput = false;
      isInvalidLocation = false;
    });

    String? type;
    var count = int.parse(participants!);
    if (count == 1) {
      type = 'One Companion';
    } else if (count > 1) {
      type = 'Group Companion';
    }

    // this one is working
    // print(scheduleDate);
    // print(scheduleTime);
    print(location);
    print(notes);

    _editedActivity = SelectActivity(
      id: activityID,
      caption: caption,
      meetUpType: 'Face to Face',
      companionType: type,
      participants: count,
      scheduleDate: _setDate,
      scheduleTime: _setTime,
      location: location,
      invitationLink: '',
      notes: notes,
    );

    //for security purposes ahahaha
    await Provider.of<Activities>(context, listen: false).createActivity(_editedActivity);

    activityID = Uuid().v4();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                // ActivitySearch(searchID: widget.interestID, searchType: widget.type, caption: caption, participants: participants)
            ActivitySearch(searchID: widget.interestID!, searchType: widget.type!, activity: _editedActivity)
        )
    );

    // print('SUCCESS');
  }

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        displayInterest(),
        inputCaption(),
        companionType(),
        invalidCompanionType(),
        invalidGroupInput(),
        invalidOneInput(),
        schedule(),
        displayLocation(),
        invalidLocation(),
        meetUpNotes(),
        search(),
        // viewInterest(context)
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              size: 30.0,
              // color: Color(0xffff3366),
              color: Colors.deepPurple[900],
            ),
          ),
        ],
      ),
    );
  }

  displayInterest() {
    return Center(
      child: Column(
        children: [
          Text(
            'Looking for someone interested in',
            style: TextStyle(
              color: Colors.deepPurple[900],
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 225,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                color: Colors.deepPurple[900]!,
              )
            ),
            child: Center(
              child: Text(
                '${widget.interest}',
                style: TextStyle(
                  color: Colors.deepPurple[900],
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0,),
        ],
      ),
    );
  }

  inputCaption() {
    return Center(
      child: Container(
        width: 300.0,
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        child: Form(
          key: _captionForm,
          child: TextFormField(
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepPurple[900],
              fontStyle: FontStyle.italic,
              // fontWeight: FontWeight.bold
            ),
            decoration: InputDecoration(
              hintText: 'Lets have coffee',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple[900]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple[900]!),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please provide a caption';
              }
              return null;
            },
            controller: captionController,
            onSaved: (value) {
              caption = value;
            },
          ),
        ),
      ),
    );
  }

  companionType() {
    return Container(
      padding: EdgeInsets.only(left: 50.0, top: 30.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isOneSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isOneSelected ? Colors.deepPurple[900] : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: isOneSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 3.0,),
                Text(
                  'One Companion',
                  style: TextStyle(
                    fontSize: 8.0,
                    color: isOneSelected ? Colors.deepPurple[900] : Colors.black,
                  ),
                ),
              ],
            ),
            onTap: () {
              // game.toggleOneCompanionType();
              setState(() {
                isOneSelected = !isOneSelected;
                print('ONE');
                print(isOneSelected);
                isGroupSelected = false;
                isCompanionSelected = false;
                isHowMany = true;
                participantsController.text = '1';
                isInvalidGroupInput = false;
              });
            },
          ),
          SizedBox(width: 30.0,),
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isGroupSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isGroupSelected ? Colors.deepPurple[900] : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.group,
                      size: 30,
                      color: isGroupSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 3.0,),
                Text(
                  'Group Companion',
                  style: TextStyle(
                    fontSize: 8.0,
                    color: isGroupSelected ? Colors.deepPurple[900] : Colors.black,
                  ),
                ),
              ],
            ),
            onTap: () {
              // toggleSelected();
              setState(() {
                isGroupSelected = !isGroupSelected;
                print('GROUP');
                print(isGroupSelected);
                isOneSelected = false;
                isCompanionSelected = false;
                isHowMany = true;
                participantsController.text = '';
                isInvalidOneInput = false;
              });
            },
          ),
          SizedBox(width: 15.0),
          Visibility(
            visible: isHowMany,
            maintainSize: false,
            maintainAnimation: false,
            maintainState: false,
            child: Container(
              width: 60,
              margin: EdgeInsets.only(bottom: 15.0),
              child: Form(
                key: _howManyForm,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurple[900],
                    fontStyle: FontStyle.italic,
                    // fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration(
                    labelText: 'Companion(s)',
                    labelStyle: TextStyle(
                      fontSize: 8.0
                    ),
                    hintText: 'How many?',
                    hintStyle: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple[900]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple[900]!),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Invalid!';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Invalid!';
                    }
                    return null;
                  },
                  controller: participantsController,
                  onSaved: (value) {
                    participants = value;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  invalidCompanionType() {
    return Container(
      padding: EdgeInsets.only(left: 40.0),
      child: Visibility(
        visible: isCompanionSelected,
        maintainSize: false,
        maintainAnimation: false,
        maintainState: false,
        child: Container(
          // width: 60,
          // padding: EdgeInsets.all(5.0),
          child: Text(
            'Select a companion type',
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  invalidGroupInput() {
    return Container(
      padding: EdgeInsets.only(left: 40.0),
      child: Visibility(
        visible: isInvalidGroupInput,
        maintainSize: false,
        maintainAnimation: false,
        maintainState: false,
        child: Container(
          // width: 60,
          // padding: EdgeInsets.all(5.0),
          child: Text(
            'Group companions must be more than 1 people',
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  invalidOneInput() {
    return Container(
      padding: EdgeInsets.only(left: 40.0),
      child: Visibility(
        visible: isInvalidOneInput,
        maintainSize: false,
        maintainAnimation: false,
        maintainState: false,
        child: Container(
          // width: 60,
          // padding: EdgeInsets.all(5.0),
          child: Text(
            'One companion must be 1 person only',
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  noScheduleSet() {
    return Visibility(
      visible: isSchedule,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Text(
        'set a schedule',
        style: TextStyle(
            color: Theme.of(context).errorColor,
            fontWeight: FontWeight.bold,
            fontSize: 11.0
        ),
      ),
    );
  }

  schedule() {
    return Container(
      margin: EdgeInsets.only(left: 30.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Date and Time',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5.0,),
          Row(
            children: [
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                  height: 40.0,
                  width: 170.0,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 14.0,
                      // color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _dateController,
                    onSaved: (String? val) {
                      _setDate = val;
                    },
                    decoration: InputDecoration(
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        // contentPadding: EdgeInsets.only(top: 5.0, bottom: 5.0)
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0,),
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 5.0),
                  height: 40.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 14.0,
                      // color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    onSaved: (String? val) {
                      _setTime = val;
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: InputDecoration(
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        // contentPadding: EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
              // isSchedule ? noScheduleSet() : Text(
              //   scheduleType,
              //   style: TextStyle(
              //       color: Theme.of(context).errorColor,
              //       // color: Colors.deepPurple[900],
              //       fontWeight: FontWeight.bold,
              //       fontSize: 11.0
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  noLocation() {
    return Visibility(
      visible: isLocation,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Text(
        'Tap to set location',
        style: TextStyle(
            // fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Colors.grey
        ),
      ),
    );
  }

  displayLocation() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: () async{
          String dataFromSetLocation = await Navigator.push(context, MaterialPageRoute(builder: (context) => SetLocation()));
          setState(() {
            location = dataFromSetLocation;
            if (location == '') {
              isLocation = true;
            } else {
              isLocation = false;
            }
          });
        },
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300.0,
                height: 55.0,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.deepPurple[900],
                    // )
                  color: Colors.deepPurple[50],
                ),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isLocation ? noLocation() : Text(
                            location!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.0,),
                          Text(
                            'Your current location',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  invalidLocation() {
    return Container(
      padding: EdgeInsets.only(left: 40.0),
      child: Visibility(
        visible: isInvalidLocation,
        maintainSize: false,
        maintainAnimation: false,
        maintainState: false,
        child: Container(
          // width: 60,
          // padding: EdgeInsets.all(5.0),
          child: Text(
            'Please set your location',
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  noNotes() {
    return Visibility(
      visible: isNotes,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Text(
        'Add meet-up notes (optional)',
        style: TextStyle(
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Colors.grey[400]
        ),
      ),
    );
  }

  meetUpNotes() {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: GestureDetector(
        onTap: () async {
          String dataFromEditNotes = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditMeetUpNotes()));
          setState(() {
            notes = dataFromEditNotes;
            if (notes == '') {
              isNotes = true;
            } else {
              isNotes = false;
            }
          });
        },
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300.0,
                height: 40.0,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.deepPurple[900]!,
                    ),
                  ),
                  // color: Colors.grey[350],
                ),
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: isNotes ? noNotes() : Text(
                        notes!,
                        style: TextStyle(
                          fontSize: 12.0,
                          // fontStyle: FontStyle.italic,
                          // color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  goSearch() {
    _submit();
  }

  search() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 30.0),
        width: 300,
        child: RaisedButton(
          onPressed: goSearch,
          elevation: 0,
          color: Colors.deepPurple[900],
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
          ),
          child: Text(
            'SEARCH COMPANION',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
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
        child: SingleChildScrollView(
          child: Container(
            child: display(),
          ),
        ),
      ),
    );
  }
}
