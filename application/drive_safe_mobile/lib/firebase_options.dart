import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase is not configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Firebase is not configured for iOS.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'Firebase is not configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Firebase is not configured for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase is not configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDy3Mhuh--pyk_ZLRSVksXq6kqOoebrApA',
    appId: '1:57641095955:android:55f0ee148d1f89117080e6',
    messagingSenderId: '57641095955',
    projectId: 'drive-safe-8e7cf',
    storageBucket: 'drive-safe-8e7cf.firebasestorage.app',
  );
}
