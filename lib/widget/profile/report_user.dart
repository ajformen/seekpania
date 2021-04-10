import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/user_account.dart';
import 'package:challenge_seekpania/models/select_report_user.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/report.dart';

class ReportUser extends StatefulWidget {

  final UserAccount user;

  ReportUser({this.user});

  @override
  _ReportUserState createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {

  var _editedReport;

  String feedback;

  TextEditingController feedbackController = TextEditingController();

  final _form = GlobalKey<FormState>();

  _submit() async{
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    print('SAVED');
    print(feedbackController.text);

    _editedReport = SelectReportUser(
      id: null,
      feedback: feedbackController.text,
    );

    await Provider.of<Report>(context, listen: false).createReport(_editedReport, widget.user.id, widget.user.firstName);

    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "You have reported this user. Rest assured we will take care of this report.",
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
        reportFeedback(),
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
                // color: Color(0xffff3366),
                color: Colors.deepPurple[900],
              ),
            ),
            SizedBox(width: 70.0,),
            Text(
              'Report this user',
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
          widget.user.photoURL,
          width: 360,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  reportFeedback() {
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: Form(
        key: _form,
        child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Tell us why are you reporting for this user?',
              hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0
              ),
            ),
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            // focusNode: _editNotesFocusNode,
            validator: (value) {
              if (value.isEmpty) {
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
