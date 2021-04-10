import 'package:flutter/material.dart';
import 'package:challenge_seekpania/widget/google_signup_button_widget.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => buildSignUp();

  Widget buildSignUp() => Column(
    children: [
      Spacer(),
      Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: 175,
          child: Center(
            child: Text(
              'seekpania',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 30,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      Spacer(),
      GoogleSignupButtonWidget(),
      SizedBox(height: 12),
      Text(
        'Login to continue',
        style: TextStyle(fontSize: 16),
      ),
      Spacer(),
    ],
  );
}