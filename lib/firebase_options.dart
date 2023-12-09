// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBEH_FMc9miKjJ32fu_ikUYnhbbeld5vtQ',
    appId: '1:815623217079:web:2177faa2d5c21b5c429232',
    messagingSenderId: '815623217079',
    projectId: 'noise-app-d9229',
    authDomain: 'noise-app-d9229.firebaseapp.com',
    storageBucket: 'noise-app-d9229.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNxsvAYGqAqxXcLW_j0dIo1IjAvSu9WUk',
    appId: '1:815623217079:android:ea7d8bb05632bfb0429232',
    messagingSenderId: '815623217079',
    projectId: 'noise-app-d9229',
    storageBucket: 'noise-app-d9229.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnn8TwnHvVhck57fX5NyBPc34wNc5Ihuo',
    appId: '1:815623217079:ios:2d5ee7ba0a23dba8429232',
    messagingSenderId: '815623217079',
    projectId: 'noise-app-d9229',
    storageBucket: 'noise-app-d9229.appspot.com',
    iosBundleId: 'com.example.futaNoiseApp',
  );
}
