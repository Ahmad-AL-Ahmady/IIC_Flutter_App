// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Pages/DeliveryNotification.dart';
import 'package:login_app/Pages/Payment.dart';
import 'package:login_app/Pages/QR_code.dart';
import 'package:login_app/Pages/ServiceTicketing.dart';
import 'package:login_app/Pages/incedents.dart';
import 'package:login_app/Pages/login.dart';
import 'package:login_app/Pages/violations.dart';
import 'alice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Dashboard extends StatefulWidget {
  String? firstname;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  BuildContext? gContext;

  @override
  void initState() {
    super.initState();
    _checkDeviceNotificationToken();

    // listening to messages in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data["orderId"]}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');

        Future.delayed(Duration(milliseconds: 100), () => {});
        Navigator.of(gContext!).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryResponse(orderId: message.data["orderId"])),
            (route) => route.isFirst);
      }
    });

    //
  }

  _checkDeviceNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    // FirebaseMessaging.instance.onTokenRefresh.listen((event) {});
  }

  // _checkNotificationMsg() {
  //   SharedPreferences.getInstance().then((value) {
  //     bool isPressed = value.getBool("notification_pressed") ?? false;
  //     if (isPressed) {
  //       value.remove("notification_pressed");
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => ChatPage()));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // _checkNotificationMsg();
    gContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', "");
          },
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Color.fromARGB(0, 34, 141, 203),
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 0, 144, 201),
                      Color.fromARGB(255, 103, 204, 255),
                      Color.fromARGB(252, 201, 229, 255),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                            child: Text(
                          "Welcome To IIC",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            width: 250,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Talk To Alice",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            width: 250,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceTicketing()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Service Ticketing",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            width: 250,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Violations()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Report Violations",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            width: 250,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Incedents()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Report Incidents",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            width: 250,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QrCode()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Generate QR Code",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            width: 250,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Payment()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Payment",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
