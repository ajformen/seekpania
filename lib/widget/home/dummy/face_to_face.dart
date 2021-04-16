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
  // DUMMY FACE TO FACE

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

  //--- date and time starts here

  bool isNowSelected = false;
  bool isLaterSelected = false;

  String? _setTime, _setDate;
  String? _hour, _minute, _time;
  String? dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  //--- date and time initialization ends here

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

  //SUBMIT
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

    _captionForm.currentState!.save();
    _howManyForm.currentState!.save();

    setState(() {
      isOneSelected = false;
      isGroupSelected = false;
      isCompanionSelected = false;
      isInvalidGroupInput = false;
      isInvalidOneInput = false;
      // isInvalidLocation = false;
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
    // print(location);
    // print(notes);

    // _editedActivity = SelectActivity(
    //   id: activityID,
    //   caption: caption,
    //   meetUpType: 'Face to Face',
    //   companionType: type,
    //   participants: count,
    //   scheduleDate: _setDate,
    //   scheduleTime: _setTime,
    //   location: location,
    //   invitationLink: '',
    //   notes: notes,
    // );

    // await Provider.of<Activities>(context, listen: false).createActivity(_editedActivity);

    // activityID = Uuid().v4();

    // Navigator.pushReplacement(
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            // ActivitySearch(searchID: widget.interestID, searchType: widget.type, caption: caption, participants: participants)
            // ActivitySearch(searchID: widget.interestID, searchType: widget.type, activity: _editedActivity)
          SetDateTime(
            searchID: widget.interestID, interestName: widget.interest, searchType: widget.type,
            caption: caption, companionType: type, participants: count,
          )
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
        // schedule(),
        // displayLocation(),
        // invalidLocation(),
        // meetUpNotes(),
        search(),
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
    return Container(
      padding: EdgeInsets.only(top: 80.0),
      child: Center(
        child: Column(
          children: [
            Text(
              'I want to meet someone interested in',
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
      ),
    );
  }

  inputCaption() {
    return Center(
      child: Container(
        width: 300.0,
        padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0),
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
      padding: EdgeInsets.only(left: 50.0, top: 60.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isOneSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isOneSelected ? Colors.deepPurple[900] : Colors.white,
                    // shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 50,
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
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isGroupSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isGroupSelected ? Colors.deepPurple[900] : Colors.white,
                    // shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.group,
                      size: 50,
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

  goSearch() {
    _submit();
  }

  search() {
    return Container(
      padding: const EdgeInsets.only(top: 60.0),
      margin: const EdgeInsets.only(left: 200.0),
      width: 150.0,
      // height: 20.0,
      child: RaisedButton(
        onPressed: goSearch,
        elevation: 0,
        color: Colors.deepPurple[900],
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
        ),
        child: Text(
          'SET DATE AND TIME',
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.white,
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
