import 'package:flutter/foundation.dart';

class SelectInterest with ChangeNotifier {
  final String id;
  final String title;
  // bool isSelected;

  SelectInterest({
    this.id,
    this.title,
    // this.isSelected = false,
});

  // void toggleSelectedStatus() {
  //   isSelected = !isSelected;
  //   notifyListeners();
  // }
}