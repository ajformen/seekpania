import 'package:flutter/foundation.dart';

class SelectInterest with ChangeNotifier {
  final String id;
  final String title;

  SelectInterest({
    required this.id,
    required this.title,
});
}