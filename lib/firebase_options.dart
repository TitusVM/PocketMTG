//According to https://firebase.google.com/docs/projects/api-keys they are NOT secret

// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBXmHVk08hHyHq7Z60s4s8FK4L_UGV-pOo',
    appId: '1:728186693365:web:dd49e0e28e49d4987247bc',
    messagingSenderId: '728186693365',
    projectId: 'pocket-mtg-71129',
    authDomain: 'pocket-mtg-71129.firebaseapp.com',
    storageBucket: 'pocket-mtg-71129.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlkgDNYjzLS3pzN9iOlUmWZDzzxETdnOk',
    appId: '1:728186693365:android:9a2f931fb0a2a45c7247bc',
    messagingSenderId: '728186693365',
    projectId: 'pocket-mtg-71129',
    storageBucket: 'pocket-mtg-71129.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvi2s42z8e25eZuNjxS2wsXeniFjTvwSA',
    appId: '1:728186693365:ios:debade5c634da1027247bc',
    messagingSenderId: '728186693365',
    projectId: 'pocket-mtg-71129',
    storageBucket: 'pocket-mtg-71129.appspot.com',
    iosBundleId: 'com.example.pocketMtg',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBvi2s42z8e25eZuNjxS2wsXeniFjTvwSA',
    appId: '1:728186693365:ios:debade5c634da1027247bc',
    messagingSenderId: '728186693365',
    projectId: 'pocket-mtg-71129',
    storageBucket: 'pocket-mtg-71129.appspot.com',
    iosBundleId: 'com.example.pocketMtg',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXmHVk08hHyHq7Z60s4s8FK4L_UGV-pOo',
    appId: '1:728186693365:web:f21a987ae5185f837247bc',
    messagingSenderId: '728186693365',
    projectId: 'pocket-mtg-71129',
    authDomain: 'pocket-mtg-71129.firebaseapp.com',
    storageBucket: 'pocket-mtg-71129.appspot.com',
  );

}