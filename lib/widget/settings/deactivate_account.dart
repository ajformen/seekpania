import 'package:flutter/material.dart';

class DeactivateAccount extends StatefulWidget {
  @override
  _DeactivateAccountState createState() => _DeactivateAccountState();
}

class _DeactivateAccountState extends State<DeactivateAccount> {

  display() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        displayMsgs(),
      ],
    );
  }

  header() {
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              size: 30.0,
              color: Color(0xffff3366),
            ),
          ),
        ],
      ),
    );
  }

  displayMsgs() {
    return Container(
      padding: const EdgeInsets.only(top: 200.0),
      child: Center(
        child: Text(
          'This user is not available',
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: display(),
          ),
        )
    );
  }
}
