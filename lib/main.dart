import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/rendering.dart';
import 'package:ndy/create_account/account.dart';
import 'package:ndy/create_account/albumupload.dart';
import 'package:ndy/create_account/signup.dart';
import 'package:ndy/create_account/singleupload.dart';
import 'package:ndy/global/constants.dart';
import 'package:ndy/global/controls.dart';
import 'package:ndy/global/uploads.dart';
import 'package:ndy/views/search_view.dart';


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

    static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfKKA-WuS2vOmL8fSry-rWUC6AVtKTw40',
    appId: '1:88256622533:android:37ba9b690b07967cb8e5ac',
    messagingSenderId: '88256622533',
    projectId: 'music-db-7a0d9',
    storageBucket: 'music-db-7a0d9.appspot.com',
    androidClientId: '88256622533-650gc6tc2367fib9c68banhuqr4h2r8d.apps.googleusercontent.com',
  );
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Component Tester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AlbumUpload(),
    );
  }
}

// class ComponentScreen extends StatelessWidget {
//   const ComponentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Create a TextEditingController for the CustomTextField
//     final TextEditingController textController = TextEditingController();

//     // Replace CustomTextField with any component you wish to test
//     // ignore: prefer_const_constructors
//     Widget componentToTest = CustomComponent(title: "tags", icon: Icons.add);
    
//     return Scaffold(
//       backgroundColor: Colors.red, // Set the background color to red
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
//             child: Column(
//               children: [

//                 const SizedBox(height: 300),
//                 componentToTest
//               ],
//             ) // Place your component here
//           ),
//         ),
//       ),
//     );
//   }
// }
