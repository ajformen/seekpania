import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';

import 'package:challenge_seekpania/widget/interest_box.dart';
import 'package:challenge_seekpania/widget/profile/rate_user.dart';
import 'package:challenge_seekpania/widget/profile/report_user.dart';

class ViewOtherUsersProfile extends StatefulWidget {

  final UserAccount user;

  ViewOtherUsersProfile({this.user});

  @override
  _ViewOtherUsersProfileState createState() => _ViewOtherUsersProfileState();
}

class _ViewOtherUsersProfileState extends State<ViewOtherUsersProfile> {
  String gender;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // print('VIEW INTEREST');
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Interest>(context).fetchAllInterests(widget.user.id).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  viewInterest() {
    final interests = Provider.of<Interest>(context, listen: false).userInterests.map((g) => InterestBox(g.title)).toList();
    // final liveEvents = Provider.of<LiveEvents>(context, listen: false).eventItems.map((g) => InterestBox(g.title)).toList();
    // final interests = games;

    return _isLoading ? Center(
        child: CircularProgressIndicator()
    ) : Wrap(
      spacing: 8,
      runSpacing: 8,
      // direction: Axis.horizontal,
      children: interests,
    );
  }

  Map favorites;
  bool isPicked;
  _ViewOtherUsersProfileState({this.favorites, this.isPicked});

  final user = FirebaseAuth.instance.currentUser;
  UserAccount currentUser;

  @override
  Widget build(BuildContext context) {

    if (widget.user.gender == 'Non-Binary') {
      gender = widget.user.genderCustom;
    } else {
      gender = widget.user.gender;
    }

    // currentUser = UserAccount(id: user.uid);
    // print('VIEW OTHER USERS PROFILE CURRENTUSER ID');
    // print(currentUser.id);
    final userFave = Provider.of<UserAccount>(context);
    // isPicked = (userFave.favorites[currentUser.id] == true);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Image.network(
                        widget.user.photoURL,
                        // 's400-c/$userPhoto',
                        // 'https://lh3.googleusercontent.com/a-/AOh14GjZwVeyNas_d37ucE1zyFcth-1b33CYoXU8lEUj=s400-c',
                        width: 390,
                        height: 412,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              height: 1.4,
                              color: Color(0xff16123d),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.user.firstName,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple[900]
                                ),
                              ),
                              TextSpan(
                                text: '\n',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple[900]
                                ),
                              ),
                              TextSpan(
                                text: widget.user.age.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: ', ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: gender,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: ', ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: widget.user.status,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '\n',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: widget.user.city,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.chat_sharp,
                                size: 26.0,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                userFave.toggleFavoriteStatus(widget.user);
                                Fluttertoast.showToast(
                                    msg: "You have favorited this user!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 13.0
                                );
                              },
                              icon: Icon(
                                // isPicked ? Icons.favorite : Icons.favorite_border,
                                Icons.favorite,
                                size: 26.0,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 25, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'INTERESTS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4e4b6f),
                          ),
                        ),
                        SizedBox(height: 14,),
                        viewInterest(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _appBar(context),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      height: 147,
      padding: EdgeInsets.fromLTRB(18.0, 0, 0, 0),
      child: Container(
        height: 34,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 24.0,
                // color: Colors.deepPurple[900],
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                buildRateReportScreen();
              },
              icon: Icon(
                Icons.more_vert,
                size: 24.0,
                // color: Colors.deepPurple[900],
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void buildRateReportScreen() => showModalBottomSheet(
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
              Icons.thumb_up,
              color: Color(0xff3b5998),
            ),
            title: Text(
              'Rate this user',
            ),
            onTap: () => {
              Navigator.of(context).pop(context),
              Navigator.push(context, MaterialPageRoute(builder: (context) => RateUser(user: widget.user))),
            }
        ),
        ListTile(
          leading: Icon(
            Icons.report,
            color: Theme.of(context).errorColor,
          ),
          title: Text(
            'Report this user',
          ),
          onTap: () => {
            Navigator.of(context).pop(context),
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReportUser(user:widget.user))),
          },
        ),
        SizedBox(height: 10.0,),
      ],
    ),
  );

}
