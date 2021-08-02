import 'package:challenge_seekpania/models/select_activity.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/widget/home/activity/people_going.dart';

class ActivityDetails extends StatefulWidget {
  final SelectActivity? info;

  ActivityDetails({
    this.info,
  });

  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {

  late String displaySched;

  @override
  void initState() {
    super.initState();
    if (widget.info!.scheduleType == 'NOW') {
      displaySched = 'Wants to meet you NOW';
    } else {
      displaySched = '${widget.info!.scheduleDate!} ${widget.info!.scheduleTime}';
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
              widget.info!.caption!,
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
          GestureDetector(
            child: Row(
              children: [
                Icon(
                  Icons.animation,
                  size: 30.0,
                ),
                SizedBox(width: 20.0,),
                Consumer<Activities>(
                  builder: (ctx, activitiesData, _) => Text(
                    activitiesData.specificActivity.length.toString(),
                    style: TextStyle(
                    ),
                  ),
                ),
                Text(
                    ' person(s) going'
                ),
              ],
            ),
            onTap: () {
              print(widget.info!.id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PeopleGoing(creatorId: widget.info!.creatorId!, activityId: widget.info!.id!)
                  )
              );
            }
          ),
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
                widget.info!.participants.toString(),
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
                widget.info!.caption!,
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          style: TextStyle(
                            color: Colors.lightBlue,
                          ),
                          text: widget.info!.location,
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            var url = widget.info!.location;
                            if (await canLaunch(url!)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        ),
                      ],
                    ),
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
              // change icon to fit the companion type
              Icon(
                Icons.group,
                size: 30.0,
              ),
              SizedBox(width: 20.0,),
              Text(
                widget.info!.companionType!
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
                widget.info!.meetUpType!,
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
                widget.info!.notes!,
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
