// ignore_for_file: deprecated_member_use, unnecessary_string_escapes

//import 'dart:ffi';

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/Pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initNotification();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString("token");
  String? fcmToken = prefs.getString("fcmToken");

  if (token != null && token != "") {
    isLoggedIn = true;

    if (fcmToken != await FirebaseMessaging.instance.getToken() &&
        fcmToken != null &&
        token != "") {
      await sendFirebaseToken(token, fcmToken);
    }
  }

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

sendFirebaseToken(String loginToken, String fcmToken) {
  Future<String> EndSession() async {
    var response = await http.post(
      Uri.https('iic-v3.herokuapp.com', '/api/v1/fcmToken'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': loginToken,
      },
      body: jsonEncode(
        {'fcmToken': fcmToken},
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      isLoggedIn = false;
      return 'failure';
    }
  }
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/New logo2.png'),
        nextScreen: isLoggedIn ? Dashboard() : const homepage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.blue,
        splashIconSize: 200,
        duration: 2000,
        animationDuration: Duration(milliseconds: 1500),
      ),
    );
  }
}
//onmessage recieved => listen