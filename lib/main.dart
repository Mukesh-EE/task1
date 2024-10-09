import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task1/studentlistscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBlLB_34ku2cdX4_CD0xPToIZtLVDyu-zc",
          appId: "1:408478713212:android:a94065e7de1a8a227350f9",
          messagingSenderId: "408478713212",
          projectId: "task1-fd979",
          storageBucket: "task1-fd979.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StudentListScreen(),
    );
  }
}
