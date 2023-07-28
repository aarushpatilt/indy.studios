import 'package:flutter/material.dart';
// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/rendering.dart';
import 'package:ndy/Backend/GlobalComponents.dart';
import 'package:ndy/FrontEnd/MainAppFlows/ProfileCustom.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/CameraUploadView.dart';
import 'package:ndy/FrontEnd/MenuFlow/LikedMoodView.dart';

import 'FrontEnd/MainAppFlows/ThreadDiscoveryView.dart';
import 'FrontEndComponents/CustomTabController.dart';
import 'FrontEndComponents/TextComponents.dart';

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfKKA-WuS2vOmL8fSry-rWUC6AVtKTw40',
    appId: '1:88256622533:ios:f7014432cb2a5335b8e5ac',
    messagingSenderId: '88256622533',
    projectId: 'music-db-7a0d9',
    storageBucket: 'music-db-7a0d9.appspot.com',
    iosClientId: '88256622533-s0pan5c582662gr5q4ki9s0hvvrn1nkg.apps.googleusercontent.com',
    iosBundleId: 'com.example.ndy',
  );
}



void main() async {
  // Disable the debug painting of overflow errors
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

//ProfileCustom(userID: GlobalVariables.userUUID,)
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomTabPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}

class MyColumnWithCreatedMoodsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 100),
        ProfileText400(text: "HEY", size: 15),
        CreatedThreadView(),
      
      ],
    );
  }
}

extension ColorExtension on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    final p = percent / 100;
    return Color.fromRGBO(
      (red * (1 - p)).round(),
      (green * (1 - p)).round(),
      (blue * (1 - p)).round(),
      opacity,
    );
  }
}