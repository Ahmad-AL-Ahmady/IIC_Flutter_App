// ignore_for_file: deprecated_member_use

import 'dart:ffi';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Pages/DeliveryNotification.dart';
import 'package:login_app/Pages/Payment.dart';
import 'package:login_app/Pages/QR_code.dart';
import 'package:login_app/Pages/ServiceTicketing.dart';
import 'package:login_app/Pages/incedents.dart';
import 'package:login_app/Pages/login.dart';
import 'package:login_app/Pages/ownerCars.dart';
import 'package:login_app/Pages/violations.dart';
import 'package:login_app/Pages/visitorslist.dart';
import 'package:login_app/main.dart';
import 'alice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  BuildContext? gContext;

  Future<void> HandleTerminatedMessage() async {
    SharedPreferences.getInstance().then((value) async {
      bool isPressed = value.getBool("notification_pressed") ?? false;
      if (isPressed) {
        RemoteMessage? initialMessage =
            await FirebaseMessaging.instance.getInitialMessage();

        if (initialMessage != null) {
          _handleMessage(initialMessage);
        }
      }
    });
  }

  Future<void> HandleBackGroundMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> HandleForegroundMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (message.data != null &&
          prefs.getBool(message.data["orderId"]) != true) {
        await Future.delayed(Duration(milliseconds: 100), () => {});
        Navigator.of(gContext!).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => DeliveryResponse(
                orderId: message.data["orderId"].toString(),
              ),
            ),
            (route) => route.isFirst);

        prefs.setBool(message.data['orderId'], true);
      }
    });
  }

  void _handleMessage(RemoteMessage message) async {
    print('YOu just enterd the function');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (message.data != null &&
        prefs.getBool(message.data["orderId"]) != true) {
      await Future.delayed(Duration(milliseconds: 100), () => {});
      Navigator.of(gContext!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => DeliveryResponse(
              orderId: message.data["orderId"].toString(),
            ),
          ),
          (route) => route.isFirst);

      prefs.setBool(message.data['orderId'], true);
    }
  }

  @override
  void initState() {
    super.initState();
    HandleTerminatedMessage();
    HandleForegroundMessage();
    HandleBackGroundMessage();
    _checkDeviceNotificationToken();
  }

  _checkDeviceNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    // _checkNotificationMsg();
    gContext = context;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "الصفحة الرئيسية",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 0, 144, 201),
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          elevation: 0,
          leading: SizedBox(
            width: 1,
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('token', "");
                prefs.setString('fcmToken', "");
              },
              label: const Text('خروج'),
              icon: const Icon(Icons.logout),
              style: ElevatedButton.styleFrom(
                  elevation: 0, primary: Colors.transparent),
            ),
          ]),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
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
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "مرحبا بك في IIC",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage())),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/Alice.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "تحدٌث مع Alice",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QrCode())),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/QR.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "رمز QR",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Incedents())),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/REPORT.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "الإبلاغ عن حادث",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Violations())),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/violation.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "الإبلاغ عن مخالفة",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceTicketing())),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/SERVICES.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "حجز خدمة",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Payment())),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/payment.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "قائمة الدفع",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ownersCars())),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/carslist.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "سياراتك الخاصة",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VisitorList())),
                                child: Card(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/Visitorslist.png",
                                            width: 80.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "قائمة الزوار",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
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
