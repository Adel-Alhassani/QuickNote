import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/auth/login.dart';
import 'package:flutter_firebase_course/auth/signup.dart';
import 'package:flutter_firebase_course/filter.dart';
import 'package:flutter_firebase_course/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyC1cJP2-vCNgVI8Zj8-ppyEUcAR_vYMQLQ",
          appId: "1:374514388930:android:ee02441142146b11a8905b",
          messagingSenderId: "374514388930",
          projectId: "flutter-firebase-course-6778b"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(
                    fontSize: 24,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.orange))),
        debugShowCheckedModeBanner: false,
        home: FilterPage()
        // (FirebaseAuth.instance.currentUser != null &&
        //         FirebaseAuth.instance.currentUser!.emailVerified)
        //     ? HomePage()
        //     : Login(),
        );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const Signup(),
//     );
//   }
// }