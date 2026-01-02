// File generated manually - Firebase configuration for ClubHub
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBGgWrOD882wosENOxu5KiDhc9y8behQxk',
    appId: '1:209780511838:web:5b2d47e31f77174bd050cf',
    messagingSenderId: '209780511838',
    projectId: 'clubhub-bc9b5',
    authDomain: 'clubhub-bc9b5.firebaseapp.com',
    storageBucket: 'clubhub-bc9b5.firebasestorage.app',
    measurementId: 'G-8XX9DBJCD1',
  );
}