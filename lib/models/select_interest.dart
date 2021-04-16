import 'package:flutter/foundation.dart';

class SelectInterest with ChangeNotifier {
  final String id;
  final String title;
  // bool isSelected;

  SelectInterest({
    required this.id,
    required this.title,
    // this.isSelected = false,
});

  // void toggleSelectedStatus() {
  //   isSelected = !isSelected;
  //   notifyListeners();
  // }
}