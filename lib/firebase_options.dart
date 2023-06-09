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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
        // throw UnsupportedError(
        //   'DefaultFirebaseOptions have not been configured for windows - '
        //   'you can reconfigure this by running the FlutterFire CLI again.',
        // );
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
    apiKey: 'AIzaSyDDCkzPH5rg2wewVZcFeGGclxW5LrpVafY',
    appId: '1:658031359368:web:ff03cc53cd81598405363d',
    messagingSenderId: '658031359368',
    projectId: 'unified-database',
    authDomain: 'unified-database.firebaseapp.com',
    storageBucket: 'unified-database.appspot.com',
    measurementId: 'G-4GKH5QTQ2C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB42K0LKCvuhlDNNRCCni2m-fKT8xj_KTg',
    appId: '1:658031359368:android:5f41eeadd6538ae205363d',
    messagingSenderId: '658031359368',
    projectId: 'unified-database',
    storageBucket: 'unified-database.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB42K0LKCvuhlDNNRCCni2m-fKT8xj_KTg',
    appId: '1:658031359368:android:5f41eeadd6538ae205363d',
    messagingSenderId: '658031359368',
    projectId: 'unified-database',
    authDomain: 'unified-database.firebaseapp.com',
  );
}
