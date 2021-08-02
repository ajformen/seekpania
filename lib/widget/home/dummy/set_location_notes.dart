import 'package:challenge_seekpania/widget/home/activity/edit_meet_up_notes.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/home/activity/set_location.dart';
import 'package:challenge_seekpania/widget/home/interests/activity_search.dart';

class SetLocationNotes extends StatefulWidget {
  final String? searchID;
  final String? interestName;
  final String? searchType;
  final String? caption;
  final String? companionType;
  final int? participants;
  final String? scheduleType;
  final String? dateFormat;
  final String? timeFormat;

  SetLocationNotes({
      this.searchID,
      this.interestName,
      this.searchType,
      this.caption,
      this.companionType,
      this.participants,
      this.scheduleType,
      this.dateFormat,
      this.timeFormat});

  @override
  _SetLocationNotesState createState() => _SetLocationNotesState();
}

class _SetLocationNotesState extends State<SetLocationNotes> {
  String activityID = Uuid().v4();
  var _editedActivity;

  String? location;
  String? notes;

  @override
  void initState() {
    print(widget.searchID);
    print(widget.interestName);
    print(widget.searchType);
    print(widget.caption);
    print(widget.companionType);
    print(widget.participants);
    print(widget.scheduleType);
    print(widget.dateFormat);
    print(widget.timeFormat);

    super.initState();
  }

  Future<void> _submit() async {
    _editedActivity = SelectActivity(
      id: activityID,
      interestName: widget.interestName,
      caption: widget.caption,
      meetUpType: 'Face to Face',
      companionType: widget.companionType,
      participants: widget.participants,
      scheduleType: widget.scheduleType,
      scheduleDate: widget.dateFormat,
      scheduleTime: widget.timeFormat,
      location: location,
      invitationLink: '',
      notes: notes,
    );

    print(activityID);
    print(widget.interestName);
    print(widget.caption);
    print(widget.companionType);
    print(widget.participants);
    print(widget.scheduleType);
    print(widget.dateFormat);
    print(widget.timeFormat);
    print(location);
    print(notes);
    print('THIS IS IT!');

    await Provider.of<Activities>(context, listen: false)
        .createActivity(_editedActivity);

    activityID = Uuid().v4();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ActivitySearch(
                    searchID: widget.searchID!,
                    searchType: widget.searchType!,
                    activity: _editedActivity)));
  }

  buildNow() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _submit();
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
                    // _isSubmit();
                    _submit();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: GestureDetector(
              onTap: () async {
                String dataFromSetLocation = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetLocation()));
                setState(() {
                  location = dataFromSetLocation;
                });
              },
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 300.0,
                      height: 70.0,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
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
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: location,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 15.0,),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ---------------
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: GestureDetector(
              onTap: () async {
                String dataFromNotes = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditMeetUpNotes()));
                setState(() {
                  notes = dataFromNotes;
                });
              },
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 300.0,
                      height: 70.0,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.edit,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: notes,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 15.0,),
                                Text(
                                  'Add meet-up notes (optional)',
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
          ),
        ],
      ),
    );
  }

  buildLater() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
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
                    _submit();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: GestureDetector(
              onTap: () async {
                String dataFromSetLocation = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetLocation()));
                setState(() {
                  location = dataFromSetLocation;
                });
              },
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 300.0,
                      height: 70.0,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: location,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 15.0,),
                                Text(
                                  'Set a  Meet-up Destination',
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
          ),
          // ---------------------------
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: GestureDetector(
              onTap: () async {
                String dataFromNotes = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditMeetUpNotes()));
                setState(() {
                  notes = dataFromNotes;
                });
              },
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 300.0,
                      height: 70.0,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.edit,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: notes,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 15.0,),
                                Text(
                                  'Add meet-up notes (optional)',
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: widget.scheduleType == 'NOW' ? buildNow() : buildLater(),
          ),
        ),
      ),
    );
  }
}
