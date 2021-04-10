import 'package:flutter/foundation.dart';

import 'package:challenge_seekpania/models/selections/select_games.dart';

class GameItem {
  final String id;
  final String title;
  final bool isSelected;

  GameItem({this.id, this.title, this.isSelected});
}

class Game with ChangeNotifier {
  List<GameItem> _orders = [];

  List<GameItem> get orders {
    return [..._orders];
  }

  void addGame(String id, String title, bool isSelected) {
    _orders.insert(0, GameItem(
      id: DateTime.now().toString(),
      title: title,
      isSelected: isSelected,
    ));
    notifyListeners();
  }
}