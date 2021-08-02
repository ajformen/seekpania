import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interest.dart';

import 'package:challenge_seekpania/widget/interest_box.dart';

class UsersProfile extends StatefulWidget {

  final UserAccount? user;

  UsersProfile({this.user});

  @override
  _UsersProfileState createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile> {
  String? gender;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Interest>(context).fetchAllInterests(widget.user!.id!).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
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

    return _isLoading ? buildLoading() : Wrap(
      spacing: 8,
      runSpacing: 8,
        children: interests,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (widget.user!.gender == 'Non-Binary') {
      gender = widget.user!.genderCustom!;
    } else {
      gender = widget.user!.gender!;
    }

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
                        widget.user!.photoURL!,
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
                            text: widget.user!.firstName,
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
                            text: widget.user!.age.toString(),
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
                            text: widget.user!.status,
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
                            text: widget.user!.city,
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
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}
