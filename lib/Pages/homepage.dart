// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:login_app/Pages/Registration/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:login_app/Pages/Registration/registration.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Image.asset(
                          "assets/New logo.png",
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Text(
                          "Welcome To IIC",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "مدينة عصرية تكنولوجية على ارض مصرية",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        )),
                        SizedBox(
                          height: 10,
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
                                        builder: (context) => LoginScreen()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        ////////////////////////////////////////

                        SizedBox(
                          height: 10,
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
                                        builder: (context) => Registration()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Color.fromARGB(255, 34, 141, 203),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
