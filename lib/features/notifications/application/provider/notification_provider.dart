import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool selectedTab = true;

  void tabSelection(bool isSelected) {
    selectedTab = isSelected;
    notifyListeners();
  }
}
