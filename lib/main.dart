// ignore_for_file: deprecated_member_use, unnecessary_string_escapes

//import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Pages/alice.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        print("App opend");
        SharedPreferences.getInstance()
            .then((value) => value.setBool("notification_pressed", true));
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Mesage recieved");
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //       notification.hashCode,
      //       notification.title,
      //       notification.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           channel.id,
      //           channel.name,
      //           icon: android.smallIcon,
      //           // other properties...
      //         ),
      //       ));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    gcontext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        // add this
        textDirection: TextDirection.rtl, // set this property
        child: AnimatedSplashScreen(
          splash: Image.asset('assets/New logo2.png'),
          nextScreen: homepage(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.blue,
          splashIconSize: 200,
          duration: 2000,
          animationDuration: Duration(milliseconds: 1000),
        ),
      ),
    );
  }
}
//onmessage recieved => listen