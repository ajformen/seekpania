import 'package:challenge_seekpania/widget/interests_grid.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interests.dart';

class SelectInterestOverview extends StatelessWidget {
  static const routeName = '/select-interest-overview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: header(context, titleText: "Select Interest"),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Select Interest",
            style: TextStyle(
              fontSize: 18.0,
              // color: Colors.deepPurple,
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => Interests(),
        child: InterestsGrid(),
      ),
    );
  }
}

