import 'package:challenge_seekpania/page/header.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interests.dart';

class InterestDetail extends StatelessWidget {

  static const routeName = '/interest-detail';

  @override
  Widget build(BuildContext context) {
    final interestId = ModalRoute.of(context).settings.arguments as String;
    final loadedInterest = Provider.of<Interests>(context).findById(interestId);
    return Scaffold(
      appBar: header(context, titleText: loadedInterest.title),
    );
  }
}
