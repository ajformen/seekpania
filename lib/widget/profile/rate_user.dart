import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_rate.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/rate.dart';

class RateUser extends StatefulWidget {

  final UserAccount? user;

  RateUser({this.user});

  @override
  _RateUserState createState() => _RateUserState();
}

class _RateUserState extends State<RateUser> {

  var _editedRate;

  bool isOneSelected = false;
  bool isTwoSelected = false;
  bool isThreeSelected = false;
  bool isFourSelected = false;
  bool isFiveSelected = false;
  bool isNoRate = false;

  String? feedback;
  double? rate;

  TextEditingController feedbackController = TextEditingController();

  final _form = GlobalKey<FormState>();

  _submit() async{

    if (isOneSelected == false && isTwoSelected == false && isThreeSelected == false && isFourSelected == false && isFiveSelected == false) {
      setState(() {
        isNoRate = true;
      });
      return;
    }

    _form.currentState!.save();
    print('SAVED');
    print(rate);
    print(feedbackController.text);

    setState(() {
      isNoRate = false;
    });

    _editedRate = SelectRate(
      id: null,
      rate: rate,
      feedback: feedbackController.text,
    );

    await Provider.of<Rate>(context, listen: false).createRating(_editedRate, widget.user!.id);

    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Rating successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 13.0
    );
  }

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        showPic(),
        showRate(),
        noRateSelected(),
        rateFeedback(),
        submit(),
      ],
    );
  }

  header() {
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
            SizedBox(width: 70.0,),
            Text(
              'Rate this user',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4e4b6f),
              ),
            ),
          ],
        ),
        // Divider(color: Color(0xff9933ff)),
      ],
    );
  }

  showPic() {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
        ),
        child: Image.network(
          widget.user!.photoURL!,
          width: 360,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  showRate() {
    return Container(
      padding: EdgeInsets.only(left: 50.0, top: 20.0, right: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isOneSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isOneSelected ? Colors.deepPurple[900] : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: isOneSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                isOneSelected = true;
                isTwoSelected = false;
                isThreeSelected = false;
                isFourSelected = false;
                isFiveSelected = false;
                isNoRate = false;
                rate = 1;
              });
            },
          ),
          // SizedBox(width: 30.0,),
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isTwoSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isTwoSelected ? Colors.deepPurple[900] : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: isTwoSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                isOneSelected = false;
                isTwoSelected = true;
                isThreeSelected = false;
                isFourSelected = false;
                isFiveSelected = false;
                isNoRate = false;
                rate = 2;
              });
            },
          ),
          // SizedBox(width: 15.0),
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isThreeSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isThreeSelected ? Colors.deepPurple[900] : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: isThreeSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                isOneSelected = false;
                isTwoSelected = false;
                isThreeSelected = true;
                isFourSelected = false;
                isFiveSelected = false;
                isNoRate = false;
                rate = 3;
              });
            },
          ),
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isFourSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isFourSelected ? Colors.deepPurple[900] : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '4',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: isFourSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                isOneSelected = false;
                isTwoSelected = false;
                isThreeSelected = false;
                isFourSelected = true;
                isFiveSelected = false;
                isNoRate = false;
                rate = 4;
              });
            },
          ),
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    border: Border.all(
                      color: isFiveSelected ? Colors.deepPurple[900]! : Colors.black,
                    ),
                    color: isFiveSelected ? Colors.deepPurple[900] : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '5',
                      style: TextStyle(
                          fontSize: 10.0,
                          color: isFiveSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                isOneSelected = false;
                isTwoSelected = false;
                isThreeSelected = false;
                isFourSelected = false;
                isFiveSelected = true;
                isNoRate = false;
                rate = 5;
              });
            },
          ),
        ],
      ),
    );
  }

  noRateSelected() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Visibility(
          visible: isNoRate,
          maintainSize: false,
          maintainAnimation: false,
          maintainState: false,
          child: Container(
            child: Text(
              'You didn\'t rate this user',
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  rateFeedback() {
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: Form(
        key: _form,
        child: TextFormField(
            decoration: InputDecoration(
              hintText: 'What are your feedback for this user?',
              hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0
              ),
            ),
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            // focusNode: _editNotesFocusNode,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your feedback.';
              }

              return null;
            },
            controller: feedbackController,
            onSaved: (value) {
              feedback = value;
            }
        ),
      ),
    );
  }

  submit() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 50.0),
        width: 300,
        child: RaisedButton(
          onPressed: () {
            _submit();
          },
          elevation: 0,
          color: Colors.deepPurple[900],
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
          ),
          child: Text(
            'SUBMIT',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: display(),
          ),
        ),
      ),
    );
  }
}
