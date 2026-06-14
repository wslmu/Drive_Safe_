import 'package:flutter/foundation.dart';

class AppNavigation {
  static final ValueNotifier<int> homeResetSignal = ValueNotifier<int>(0);

  static void goHome() {
    homeResetSignal.value++;
  }
}
