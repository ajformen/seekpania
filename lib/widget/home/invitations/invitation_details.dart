import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/select_invite.dart';

class InvitationDetails extends StatefulWidget {
  final SelectInvite? user;

  InvitationDetails({this.user});

  @override
  _InvitationDetailsState createState() => _InvitationDetailsState();
}

class _InvitationDetailsState extends State<InvitationDetails> {
  late String displaySched;

  @override
  void initState() {
    super.initState();
    if (widget.user!.scheduleType == 'NOW') {
      displaySched = 'Wants to meet you NOW';
    } else {
      displaySched = '${widget.user!.scheduleDate!} ${widget.user!.scheduleTime}';
    }
  }

  display(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(context),
        details(),
      ],
    );
  }

  header(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () =>
                  Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_sharp,
                size: 30.0,
                color: Colors.deepPurple[900],
              ),
            ),
            Text(
              widget.user!.caption!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff4e4b6f),
              ),
            ),
          ],
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }

  details() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0,),
          Row(
            children: [
              Icon(
                Icons.find_in_page,
                size: 30,
              ),
              SizedBox(width: 20.0,),
              Text(
                'Need (',
              ),
              Text(
                widget.user!.participants.toString(),
              ),
              Text(
                ')',
              ),
              Text(
                ' companion(s)',
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            children: [
              Icon(
                Icons.event_note,
                size: 30,
              ),
              SizedBox(width: 20.0,),
              Text(
                widget.user!.caption!,
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 30,
              ),
              SizedBox(width: 20.0,),
              Text(
                displaySched,
                style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 30,
                color: Theme.of(context).errorColor,
              ),
              SizedBox(width: 20.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user!.location!,
                  ),
                  // Text(
                  //   'Cebu, Philippines'
                  // ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            children: [
              Icon(
                Icons.group,
                size: 30.0,
              ),
              SizedBox(width: 20.0,),
              Text(
                  widget.user!.companionType!
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            children: [
              Icon(
                Icons.accessibility,
                size: 30.0,
              ),
              SizedBox(width: 20.0,),
              Text(
                widget.user!.meetUpType!,
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Row(
            children: [
              Icon(
                Icons.edit,
                size: 30.0,
              ),
              SizedBox(width: 20.0,),
              Text(
                widget.user!.notes!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: display(context),
        ),
      ),
    );
  }
}
