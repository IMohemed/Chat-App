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
    apiKey: 'AIzaSyDHzuKRIBiwk2jjF8SlLusuQlHQy7jSL3I',
    appId: '1:649131614603:web:4e6e0cb12db91a34394f8e',
    messagingSenderId: '649131614603',
    projectId: 'chat-app-6dc1c',
    authDomain: 'chat-app-6dc1c.firebaseapp.com',
    storageBucket: 'chat-app-6dc1c.appspot.com',
    measurementId: 'G-QWVH6MP5KF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDCEHZqVt-WkaavbMU-xdxe3t-iQUJ4IU',
    appId: '1:649131614603:android:d239d82c8d7a02ed394f8e',
    messagingSenderId: '649131614603',
    projectId: 'chat-app-6dc1c',
    storageBucket: 'chat-app-6dc1c.appspot.com',
  );
}
