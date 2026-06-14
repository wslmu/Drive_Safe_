import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  static bool _initialized = false;
  static bool _enabled = false;

  static bool get isEnabled => _enabled;

  static String? get uid {
    if (!_enabled) return null;
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      if (kIsWeb) {
        _enabled = false;
        return;
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.iOS:
          await Firebase.initializeApp();
          _enabled = true;
          break;
        default:
          _enabled = false;
          return;
      }
    } catch (_) {
      _enabled = false;
      return;
    }
  }
}
