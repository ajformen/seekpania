import 'package:challenge_seekpania/models/selections/select_sports.dart';
import 'package:challenge_seekpania/provider/emergencies.dart';
import 'package:challenge_seekpania/provider/messages.dart';
import 'package:challenge_seekpania/provider/selections/chaperones.dart';
import 'package:challenge_seekpania/provider/selections/outdoors.dart';
import 'package:challenge_seekpania/provider/selections/readings.dart';
import 'package:challenge_seekpania/provider/selections/sports.dart';
import 'package:challenge_seekpania/widget/interest_detail.dart';
import 'package:challenge_seekpania/widget/outdoors/select_outdoors_overview.dart';
import 'package:challenge_seekpania/widget/reading/select_reading_overview.dart';
import 'package:challenge_seekpania/widget/sports/select_sports_overview.dart';
import 'package:flutter/material.dart';
import 'package:challenge_seekpania/page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:challenge_seekpania/models/selections/select_games.dart';
import 'package:challenge_seekpania/models/selections/select_live_event.dart';
import 'package:challenge_seekpania/models/selections/select_music.dart';
import 'package:challenge_seekpania/models/selections/select_movies.dart';

import 'package:challenge_seekpania/models/select_invite.dart';
import 'package:challenge_seekpania/models/select_activity.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';
import 'package:challenge_seekpania/provider/interests.dart';
import 'package:challenge_seekpania/provider/invitations.dart';
import 'package:challenge_seekpania/provider/activities.dart';

import 'package:challenge_seekpania/provider/selections/games.dart';
import 'package:challenge_seekpania/provider/selections/live_events.dart';
import 'package:challenge_seekpania/provider/selections/musics.dart';
import 'package:challenge_seekpania/provider/selections/movies.dart';

import 'package:challenge_seekpania/provider/rate.dart';
import 'package:challenge_seekpania/provider/report.dart';


import 'package:challenge_seekpania/widget/select_interest_overview.dart';

import 'package:challenge_seekpania/widget/games/select_game_overview.dart';
import 'package:challenge_seekpania/widget/live_events/select_live_events_overview.dart';
import 'package:challenge_seekpania/widget/music/select_music_overview.dart';
import 'package:challenge_seekpania/widget/movies/select_movies_overview.dart';

import 'package:challenge_seekpania/widget/admin/games/games_screen.dart';
import 'package:challenge_seekpania/widget/admin/games/edit_game_screen.dart';

import 'package:challenge_seekpania/widget/admin/events/events_screen.dart';
import 'package:challenge_seekpania/widget/admin/events/edit_event_screen.dart';

import 'package:challenge_seekpania/widget/admin/music/music_screen.dart';
import 'package:challenge_seekpania/widget/admin/music/edit_music_screen.dart';

import 'package:challenge_seekpania/widget/admin/movies/movies_screen.dart';
import 'package:challenge_seekpania/widget/admin/movies/edit_movies_screen.dart';

import 'package:challenge_seekpania/widget/home/interests/activity_interest_screen.dart';
import 'package:challenge_seekpania/widget/virtual/virtual_activity_interest_screen.dart';

import 'models/selections/select_outdoors.dart';
import 'models/selections/select_reading.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Seekpania';

  // @override
  // Widget build(BuildContext context) => MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   title: title,
  //   theme: ThemeData(primarySwatch: Colors.deepPurple),
  //   home: HomePage(),
  //   routes: {
  //     InterestDetail.routeName: (ctx) => InterestDetail(),
  //   },
  // );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Interests(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Games(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LiveEvents(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Musics(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Movies(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Readings(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Outdoors(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Sports(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectGames(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectLiveEvent(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectMusic(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectMovies(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectReading(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectOutdoors(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectSports(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Interest(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Invitations(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectInvite(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectActivity(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Activities(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserAccount(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Rate(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Report(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Messages(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Chaperones(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Emergencies(),
        ),
        //add more here...
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: HomePage(),
        routes: {
          InterestDetail.routeName: (ctx) => InterestDetail(),
          GamesScreen.routeName: (ctx) => GamesScreen(),
          EventsScreen.routeName: (ctx) => EventsScreen(),
          MusicScreen.routeName: (ctx) => MusicScreen(),
          MoviesScreen.routeName: (ctx) => MoviesScreen(),
          EditGameScreen.routeName: (ctx) => EditGameScreen(),
          EditEventScreen.routeName: (ctx) => EditEventScreen(),
          EditMusicScreen.routeName: (ctx) => EditMusicScreen(),
          EditMoviesScreen.routeName: (ctx) => EditMoviesScreen(),
          SelectInterestOverview.routeName: (ctx) => SelectInterestOverview(),
          SelectGameOverview.routeName: (ctx) => SelectGameOverview(),
          SelectLiveEventsOverview.routeName: (ctx) => SelectLiveEventsOverview(),
          SelectMusicOverview.routeName: (ctx) => SelectMusicOverview(),
          SelectMoviesOverview.routeName: (ctx) => SelectMoviesOverview(),
          SelectReadingOverview.routeName: (ctx) => SelectReadingOverview(),
          SelectOutdoorsOverview.routeName: (ctx) => SelectOutdoorsOverview(),
          SelectSportsOverview.routeName: (ctx) => SelectSportsOverview(),
          ActivityInterestScreen.routeName: (ctx) => ActivityInterestScreen(),
          VirtualActivityInterestScreen.routeName: (ctx) => VirtualActivityInterestScreen(),
        },
      ),
    );
  }
}