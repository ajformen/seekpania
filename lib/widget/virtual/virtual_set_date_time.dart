import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/virtual/virtual_set_location_link_notes.dart';

class VirtualSetDateTime extends StatefulWidget {
  final String? searchID;
  final String? interestName;
  final String? searchType;
  final String? caption;
  final String? companionType;
  final int? participants;

  VirtualSetDateTime({this.searchID, this.interestName, this.searchType, this.caption, this.companionType, this.participants});


  @override
  _VirtualSetDateTimeState createState() => _VirtualSetDateTimeState();
}

class _VirtualSetDateTimeState extends State<VirtualSetDateTime> {

  String? scheduleType;

  bool isNowSelected = false;
  bool isLaterSelected = false;
  bool isReveal = false;
  bool isNow = false;
  bool checkNowLater = false;

  double? _height;
  double? _width;

  String? _setTime, _setDate;
  String? _hour, _minute, _time;
  String? dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  _isSubmit() {
    if (isNowSelected == false && isLaterSelected == false) {
      setState(() {
        checkNowLater = true;
      });
      return;
    }
    String? _dateFormat, _timeFormat;

    if (isNowSelected == true) {
      scheduleType = 'NOW';
      _dateFormat = '';
      _timeFormat = '';
    } else if (isLaterSelected == true) {
      scheduleType = 'LATER';
      _dateFormat = _dateController.text;
      _timeFormat = _timeController.text;
    }
    print('TYPE');
    print(scheduleType);

    // Navigator.pop(context, type);

    // print(widget.searchID);
    // print(widget.interestName);
    // print(widget.searchType);
    // print(widget.caption);
    // print(widget.companionType);
    // print(widget.participants);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VirtualSetLocationLinkNotes(
                  searchID: widget.searchID, interestName: widget.interestName, searchType: widget.searchType,
                  caption: widget.caption, companionType: widget.companionType, participants: widget.participants,
                  scheduleType: scheduleType, dateFormat: _dateFormat, timeFormat: _timeFormat,
                )
        )
    );
  }

  display() {
    return Column(
      children: [
        header(),
        buildNowOrLater(),
        buildScheduleType(),
        buildNow(),
        buildDate(),
        buildTime(),
      ],
    );
  }

  header() {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              // _isSubmit();
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              size: 30.0,
              color: Colors.deepPurple[900],
            ),
          ),
          GestureDetector(
            child: Text(
              'Next',
              style: TextStyle(
                color: Colors.deepPurple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              _isSubmit();
            },
          ),
        ],
      ),
    );
  }

  buildNowOrLater() {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          Center(
            child: Text(
                'Do you want to meet your companion'
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.only(left: 30.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 130.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          border: Border.all(
                            color: isNowSelected ? Colors.red : Colors.black,
                          ),
                          color: isNowSelected ? Colors.red : Colors.white,
                          // shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'NOW',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: isNowSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // game.toggleOneCompanionType();
                    setState(() {
                      isNowSelected = !isNowSelected;
                      print('NOW');
                      print(isNowSelected);
                      isLaterSelected = false;
                      isReveal = false;
                      isNow = true;
                      checkNowLater = false;
                    });
                  },
                ),
                SizedBox(width: 10.0,),
                Text(
                  'or',
                ),
                SizedBox(width: 10.0,),
                GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 130.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          border: Border.all(
                            color: isLaterSelected ? Colors.yellow[800]! : Colors.black,
                          ),
                          color: isLaterSelected ? Colors.yellow[800] : Colors.white,
                          // shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'LATER',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: isLaterSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // toggleSelected();
                    setState(() {
                      isLaterSelected = !isLaterSelected;
                      print('LATER');
                      print(isLaterSelected);
                      isNowSelected = false;
                      isReveal = true;
                      isNow = false;
                      checkNowLater = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
    print('VIRTUAL GATHERING!');
    print(widget.searchID);
    print(widget.interestName);
    print(widget.searchType);
    print(widget.caption);
    print(widget.companionType);
    print(widget.participants);

    _dateController.text = DateFormat('MMMM-dd-yyyy').format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    super.initState();
  }

  buildScheduleType() {
    return Visibility(
      visible: checkNowLater,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Container(
        padding: EdgeInsets.only(top: 100.0),
        child: Text(
          'Please select your schedule type.',
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
    );
  }

  buildNow() {
    return Visibility(
      visible: isNow,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Container(
        padding: EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Text(
                'You will meet your companion right'
            ),
            Text(
                'this moment online.'
            ),
          ],
        ),
      ),
    );
  }

  buildDate() {
    return Visibility(
      visible: isReveal,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Container(
        width: _width,
        height: _height,
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Choose Date',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    // width: _width / 1.7,
                    // height: _height / 9,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.deepPurple[50]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 22),
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
                          contentPadding: EdgeInsets.only(top: 0.0)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildTime() {
    return Visibility(
      visible: isReveal,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Container(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            Text(
              'Choose Time',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
            InkWell(
              onTap: () {
                _selectTime(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 30),
                width: _width,
                height: _height,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.deepPurple[50]),
                child: TextFormField(
                  style: TextStyle(fontSize: 26),
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
                      contentPadding: EdgeInsets.all(5)
                  ),
                ),
              ),
            ),
          ],
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
