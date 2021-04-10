import 'package:flutter/material.dart';

import 'package:challenge_seekpania/widget/select_interest_item.dart';

import 'package:provider/provider.dart';
import 'package:challenge_seekpania/provider/interests.dart';

class InterestsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final interestsData = Provider.of<Interests>(context);
    final interests = interestsData.items;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0),
      itemCount: interests.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (c) => interests[i],
        child: SelectInterestItem(
          // interests[i].id,
          // interests[i].title,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 7,
      ),
    );
  }
}