// ignore_for_file: deprecated_member_use, unnecessary_string_escapes

//import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:login_app/Pages/Testdash.dart';
// import 'package:flutter/services.dart';
// import 'package:login_app/Pages/DeliveryNotification.dart';
// import 'package:login_app/Pages/Registration/registerationotp.dart';
// import 'package:login_app/Pages/Registration/registration2.dart';
// import 'package:login_app/Pages/alice.dart';
// import 'package:login_app/Pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/DeliveryNotification.dart';
import 'Pages/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

BuildContext? gcontext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebasemessagingbackgroundhandler);
  runApp(const MyApp());
}

_initNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebasemessagingbackgroundhandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> _firebasemessagingbackgroundhandler(RemoteMessage message) async {
  print('A new message just showed up: ${message.messageId}');
  SharedPreferences.getInstance()
      .then((value) => value.setBool("notification_pressed", true));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext? gContext;

  @override
  void initState() {
    super.initState();
    //setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    gcontext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/New logo2.png'),
        nextScreen: homepage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.blue,
        splashIconSize: 200,
        duration: 2000,
        animationDuration: Duration(milliseconds: 3000),
      ),
    );
  }
}
//onmessage recieved => listen