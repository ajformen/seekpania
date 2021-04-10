import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/home/activity/set_location.dart';

class VirtualSetLocationLinkNotes extends StatefulWidget {
  final String searchID;
  final String interestName;
  final String searchType;
  final String caption;
  final String companionType;
  final int participants;
  final String scheduleType;
  final String dateFormat;
  final String timeFormat;

  VirtualSetLocationLinkNotes({this.searchID, this.interestName, this.searchType, this.caption, this.companionType, this.participants, this.scheduleType, this.dateFormat, this.timeFormat});

  @override
  _VirtualSetLocationLinkNotesState createState() => _VirtualSetLocationLinkNotesState();
}

class _VirtualSetLocationLinkNotesState extends State<VirtualSetLocationLinkNotes> {
  bool isLocation = true;
  bool isLink = true;

  String location;
  // String notes;

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
    print(widget.scheduleType);
    print(widget.dateFormat);
    print(widget.timeFormat);

    // if (widget.scheduleType == 'NOW') {
    //   buildNow();
    // } else if (widget.scheduleType == 'LATER') {
    //   buildLater();
    // }

    super.initState();
  }

  noLocation() {
    return Visibility(
      visible: isLocation,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Text(
        'Tap to select country',
        style: TextStyle(
          // fontSize: 12.0,
            fontStyle: FontStyle.italic,
            color: Colors.grey
        ),
      ),
    );
  }

  noLink() {
    return Visibility(
      visible: isLink,
      maintainSize: false,
      maintainAnimation: false,
      maintainState: false,
      child: Container(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          'Add invitation link',
          style: TextStyle(
            // fontSize: 12.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
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
                    // _isSubmit();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.0),
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
                      height: 70.0,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isLocation ? noLocation() : Text(
                                  location,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // SizedBox(height: 15.0,),
                                Text(
                                  'Choose a country to match',
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
          Container(
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
                      height: 70.0,
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
                              Icons.video_call,
                              // color: Colors.red,
                            ),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.only(left: 15.0),
                          //   child: isLocation ? noLocation() : Text(
                          //     location,
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                              child: Column(
                                children: <Widget>[
                                  isLink ? noLink() : Text(
                                    location,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
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
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Center(
              child: Container(
                width: 300.0,
                // height: 70.0,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.deepPurple[900],
                  // )
                  color: Colors.deepPurple[50],
                ),
                child: Form(
                  // key: _form,
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Notes for your companion.',
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14.0
                        ),
                      ),
                      maxLines: 13,
                      keyboardType: TextInputType.multiline,
                      // focusNode: _editNotesFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter location.';
                        }

                        return null;
                      },
                      // controller: notesController,
                      onSaved: (value) {
                        // notes = value;
                      }
                  ),
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
                    // _isSubmit();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50.0),
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
                      height: 70.0,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // isLocation ? noLocation() :
                                isLocation ? noLocation() : Text(
                                  location,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // SizedBox(height: 15.0,),
                                Text(
                                  'Choose a country to match',
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
          Container(
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
                      height: 70.0,
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
                              Icons.video_call,
                              // color: Colors.red,
                            ),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.only(left: 15.0),
                          //   child: isLocation ? noLocation() : Text(
                          //     location,
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                              child: Column(
                                children: <Widget>[
                                  isLink ? noLink() : Text(
                                    location,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
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
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Center(
              child: Container(
                width: 300.0,
                // height: 70.0,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.deepPurple[900],
                  // )
                  color: Colors.deepPurple[50],
                ),
                child: Form(
                  // key: _form,
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Notes for your companion.',
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14.0
                        ),
                      ),
                      maxLines: 13,
                      keyboardType: TextInputType.multiline,
                      // focusNode: _editNotesFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter location.';
                        }

                        return null;
                      },
                      // controller: notesController,
                      onSaved: (value) {
                        // notes = value;
                      }
                  ),
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
