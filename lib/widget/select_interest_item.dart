import 'package:challenge_seekpania/models/select_interest.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';

import 'package:challenge_seekpania/widget/games/select_game_overview.dart';
import 'package:challenge_seekpania/widget/live_events/select_live_events_overview.dart';
import 'package:challenge_seekpania/widget/music/select_music_overview.dart';
import 'package:challenge_seekpania/widget/movies/select_movies_overview.dart';


class SelectInterestItem extends StatefulWidget {
  @override
  _SelectInterestItemState createState() => _SelectInterestItemState();
}

class _SelectInterestItemState extends State<SelectInterestItem> {

  checkInterest() {
    final interest = Provider.of<SelectInterest>(context, listen: false);
    if (interest.id == 'select1') {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             SelectGameOverview()
      //     )
      // );
      Navigator.of(context).pushNamed(SelectGameOverview.routeName);
    } else if (interest.id == 'select2') {
      Navigator.of(context).pushNamed(SelectLiveEventsOverview.routeName);
    } else if (interest.id == 'select3') {
      Navigator.of(context).pushNamed(SelectMusicOverview.routeName);
    } else if (interest.id == 'select4') {
      Navigator.of(context).pushNamed(SelectMoviesOverview.routeName);
    } else {
      print('WORK IN PROGRESS, KINDLY WAIT. THANK YOU');
    }
  }

  @override
  Widget build(BuildContext context) {
    final interest = Provider.of<SelectInterest>(context);
    final itrst = Provider.of<Interest>(context);
    // final theGame = Provider.of<Game>(context);
    return GridTile(
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(
            //   width: 1,
            //   color: Colors.deepPurple[900],
            // ),
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
          // interest.toggleSelectedStatus();
          // itrst.addItem(interest.id, interest.title);
        }
      ),
    );
  }
}

