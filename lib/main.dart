import 'dart:js_util';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Service/Notification_service.dart';
import 'package:flutter_firebase/Service/auth_gate.dart';
import 'package:flutter_firebase/Service/firbaseApi.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/pages/signin.dart';
import 'package:flutter_firebase/pages/signup.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  firbaseApi().init;
  await NotificationService.initializeNotification();
  
  runApp(const MyApp());

}


class MyApp extends StatelessWidget  {
  const MyApp({super.key});
   static GlobalKey<NavigatorState> navigateKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigateKey,
      home: const AuthGate(),
      
    );
  }
}


