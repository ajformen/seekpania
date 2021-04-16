import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';

import 'package:challenge_seekpania/widget/interest_box.dart';

class ViewUsersProfile extends StatefulWidget {

  final String? userId;

  ViewUsersProfile({this.userId});

  @override
  _ViewUsersProfileState createState() => _ViewUsersProfileState();
}

class _ViewUsersProfileState extends State<ViewUsersProfile> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  late UserAccount currentUser;
  String? gender;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // print('VIEW INTEREST');
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Interest>(context).fetchAllInterests(widget.userId!).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      // Provider.of<LiveEvents>(context).fetchLiveEventInterests().then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      // CustomPaint(painter: BackgroundPainter()),
      Center(child: CircularProgressIndicator()),
    ],
  );

  viewInterest() {
    final interests = Provider.of<Interest>(context, listen: false).userInterests.map((g) => InterestBox(g.title!)).toList();
    // final liveEvents = Provider.of<LiveEvents>(context, listen: false).eventItems.map((g) => InterestBox(g.title)).toList();
    // final interests = games;

    return _isLoading ? buildLoading() : Wrap(
      spacing: 8,
      runSpacing: 8,
      // direction: Axis.horizontal,
      children: interests,
    );
  }

  @override
  Widget build(BuildContext context) {
    // String userPhoto = widget.user.photoURL;
    // String originalPhoto = 's96-c/$userPhoto';
    // String newPhoto = 's400-c/$userPhoto';
    //
    // String photoPath = userPhoto;
    //
    // String result = photoPath.replaceAll(originalPhoto, newPhoto);
    // print('THE NEW PHOTO URL');
    // print(result);

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(widget.userId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buildLoading();
          }
          currentUser = UserAccount.fromDocument(snapshot.data!);
          if (currentUser.gender == 'Non-Binary') {
            gender = currentUser.genderCustom;
          } else {
            gender = currentUser.gender;
          }
          return Stack(
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
                            currentUser.photoURL!,
                            // 's400-c/$userPhoto',
                            // 'https://lh3.googleusercontent.com/a-/AOh14GjZwVeyNas_d37ucE1zyFcth-1b33CYoXU8lEUj=s400-c',
                            width: 390,
                            height: 412,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16, left: 25),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              height: 1.4,
                              color: Color(0xff16123d),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: currentUser.firstName,
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
                                text: currentUser.age.toString(),
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
                                text: currentUser.status,
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
                                text: currentUser.city,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
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
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(25, 25, 24, 0),
                      //   child: viewInterest(),
                      // ),
                    ],
                  ),
                ),
              ),
              _appBar(context),
            ],
          );
        }
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      height: 147,
      padding: EdgeInsets.fromLTRB(18.0, 0, 24, 0),
      child: Container(
        height: 34,
        child: GestureDetector(
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
      ),
    );
  }

}
