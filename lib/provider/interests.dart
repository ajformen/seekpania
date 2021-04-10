import 'package:flutter/material.dart';

import 'package:challenge_seekpania/models/select_interest.dart';

class Interests with ChangeNotifier {
  List<SelectInterest> _items = [
    SelectInterest(
      id: 'select1',
      title: 'Games',
    ),
    SelectInterest(
      id: 'select2',
      title: 'Live Events',
    ),
    SelectInterest(
      id: 'select3',
      title: 'Music',
    ),
    SelectInterest(
      id: 'select4',
      title: 'Movies',
    ),
    SelectInterest(
      id: 'select5',
      title: 'Reading',
    ),
    SelectInterest(
      id: 'select6',
      title: 'Relationships',
    ),
    SelectInterest(
      id: 'select7',
      title: 'Fitness & Wellness',
    ),
    SelectInterest(
      id: 'select8',
      title: 'Food & Drink',
    ),
    SelectInterest(
      id: 'select9',
      title: 'Hobbies & Activities',
    ),
    SelectInterest(
      id: 'select10',
      title: 'Shopping & Fashion',
    ),
    SelectInterest(
      id: 'select11',
      title: 'Sports & Outdoors',
    ),
  ];

  List<SelectInterest> get items {
    return [..._items];
  }

  SelectInterest findById(String id) {
    return _items.firstWhere((itrst) => itrst.id == id);
  }

  void addInterest() {
    // _items.add(value);
    notifyListeners();
  }
}