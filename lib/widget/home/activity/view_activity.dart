import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/select_invite.dart';
import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/invitations.dart';

import 'package:challenge_seekpania/widget/home/activity/view_users_profile.dart';
import 'package:challenge_seekpania/widget/home/invitations/invitation_details.dart';
import 'package:challenge_seekpania/widget/home/activity/my_activity.dart';
import 'package:challenge_seekpania/widget/account.dart';

class ViewActivity extends StatefulWidget {
  final SelectInvite user;

  ViewActivity({this.user});

  @override
  _ViewActivityState createState() => _ViewActivityState();
}

class _ViewActivityState extends State<ViewActivity> {
  final user = FirebaseAuth.instance.currentUser;
  UserAccount currentUser;
  var _editedActivityInvite;
  var _isLoading = false;

  // @override
  // void initState() {
  //   print('ACTIVITY ID');
  //   print(widget.user.activityID);
  //   super.initState();
  // }

  void buildViewScreen() => showModalBottomSheet(
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
        ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.deepPurple[900],
            ),
            title: Text(
              'View Profile',
            ),
            onTap: () => {
              // Navigator.of(context).pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ViewUsersProfile(userId: widget.user.creatorId);
              }))
            }
        ),
        ListTile(
          leading: Icon(
            Icons.mail_outline_outlined,
            color: Colors.deepPurple[900],
          ),
          title: Text(
            'View Invitation',
          ),
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return InvitationDetails(user: widget.user);
            }))
          },
        ),
        SizedBox(height: 10.0,),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    // currentUser = UserAccount(id: user.uid);
    final invite = Provider.of<SelectInvite>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _appBar(),
            GestureDetector(
              onTap: () {
                buildViewScreen();
              },
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      // 'https://i.pinimg.com/originals/40/f2/2d/40f22d2f7b06086fe24527467bf0a8af.jpg',
                      widget.user.creatorPhoto,
                      width: 366,
                      height: 550,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 40,
                    child: Container(
                      width: 342,
                      height: 104,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        )
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 22, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              // 'Have coffee with me',
                              widget.user.caption,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            Text(
                              // 'Bae Suzy, 26',
                              widget.user.creatorName,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 90.0, right: 110.0),
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async{
                      setState(() {
                        _isLoading = true;
                      });
                      currentUser = UserAccount(id: user.uid);
                      invite.pressDeclined(widget.user.id, currentUser.id);
                      setState(() {
                        _isLoading = false;
                      });
                      Fluttertoast.showToast(
                          msg: "You declined this invitation!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 13.0
                      );
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.cancel,
                      size: 50.0,
                      // color: Color(0xfffefefe),
                      color: Theme.of(context).errorColor
                    ),
                  ),
                  IconButton(
                    onPressed: () async{
                      setState(() {
                        _isLoading = true;
                      });
                      currentUser = UserAccount(id: user.uid);

                      _editedActivityInvite = SelectInvite(
                        activityID: widget.user.activityID,
                        caption: widget.user.caption,
                        meetUpType: widget.user.meetUpType,
                        companionType: widget.user.companionType,
                        participants: widget.user.participants,
                        schedule: widget.user.schedule,
                        location: widget.user.location,
                        notes: widget.user.notes,
                        creatorId: widget.user.creatorId,
                        creatorName: widget.user.creatorName,
                        creatorPhoto: widget.user.creatorPhoto,
                        type: widget.user.type
                      );

                      invite.pressAccepted(_editedActivityInvite, widget.user.id, currentUser.id);
                      // invite.pressAccepted(widget.user.creatorId, widget.user.activityID, widget.user.id, currentUser.id);

                      setState(() {
                        _isLoading = false;
                      });

                      Fluttertoast.showToast(
                          msg: "Invitation Accepted!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 13.0
                      );

                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyActivity()));
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 50.0,
                      color: Color(0xff2fc47a),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return _isLoading ? Center(
      child: CircularProgressIndicator(),
    ) : Container(
      child: Container(
        // decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.5),
        // ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_sharp,
                size: 30.0,
                // color: Color(0xfffefefe),
                color: Colors.deepPurple[900],
              ),
            ),
            SizedBox(width: 85.0,),
            Text(
              'Invites You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4e4b6f),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
