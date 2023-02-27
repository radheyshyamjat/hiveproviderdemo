import 'package:flutter/widgets.dart';

class ChangeScreenProvider extends ChangeNotifier {
  bool isEnableAddTask = false;

  void changeAddTaskState({bool enable = false}) {
    isEnableAddTask = enable;
    notifyListeners();
  }
}
