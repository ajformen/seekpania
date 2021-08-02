import 'package:challenge_seekpania/models/select_interest.dart';
import 'package:challenge_seekpania/widget/reading/select_reading_overview.dart';
import 'package:challenge_seekpania/widget/sports/select_sports_overview.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:challenge_seekpania/widget/games/select_game_overview.dart';
import 'package:challenge_seekpania/widget/live_events/select_live_events_overview.dart';
import 'package:challenge_seekpania/widget/music/select_music_overview.dart';
import 'package:challenge_seekpania/widget/movies/select_movies_overview.dart';

import 'outdoors/select_outdoors_overview.dart';


class SelectInterestItem extends StatefulWidget {
  @override
  _SelectInterestItemState createState() => _SelectInterestItemState();
}

class _SelectInterestItemState extends State<SelectInterestItem> {

  checkInterest() {
    final interest = Provider.of<SelectInterest>(context, listen: false);
    if (interest.id == 'select1') {
      Navigator.of(context).pushNamed(SelectGameOverview.routeName);
    } else if (interest.id == 'select2') {
      Navigator.of(context).pushNamed(SelectLiveEventsOverview.routeName);
    } else if (interest.id == 'select3') {
      Navigator.of(context).pushNamed(SelectMusicOverview.routeName);
    } else if (interest.id == 'select4') {
      Navigator.of(context).pushNamed(SelectMoviesOverview.routeName);
    } else if (interest.id == 'select5') {
      Navigator.of(context).pushNamed(SelectReadingOverview.routeName);
    }else if (interest.id == 'select6') {
      Navigator.of(context).pushNamed(SelectOutdoorsOverview.routeName);
    } else if (interest.id == 'select7') {
      Navigator.of(context).pushNamed(SelectSportsOverview.routeName);
    } else {
      print('WORK IN PROGRESS, KINDLY WAIT. THANK YOU');
    }
  }

  @override
  Widget build(BuildContext context) {
    final interest = Provider.of<SelectInterest>(context);
    return GridTile(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepPurple[900],
          ),
          padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0),
          child: Text(
            interest.title,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        onTap: () {
          checkInterest();
        }
      ),
    );
  }
}

