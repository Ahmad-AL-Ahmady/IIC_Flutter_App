// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Pages/incedents.dart';
import 'package:login_app/Pages/login.dart';
import 'package:login_app/Pages/services.dart';
import 'package:login_app/Pages/violations.dart';
import 'alice.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 2, 47, 98),
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
              elevation: 0, primary: Colors.transparent),
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
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 0, 43, 91),
                      Color.fromARGB(255, 43, 72, 101),
                      Color.fromARGB(255, 37, 109, 133),
                      Color.fromARGB(255, 143, 227, 207),
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
                          "Welcome in IIC",
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
                              color: Color(0xff3c6970),
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
                                        builder: (context) => Services()));
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color(0xff3c6970),
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
                              color: Color(0xff3c6970),
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
                              color: Color(0xff3c6970),
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
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 25),
                        //   child: Container(
                        //     width: 250,
                        //     child: RaisedButton(
                        //       onPressed: () {},
                        //       splashColor: Colors.white,
                        //       elevation: 20,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(50),
                        //       ),
                        //       color: Color(0xff3c6970),
                        //       padding: EdgeInsets.all(30),
                        //       child: Text(
                        //         "Visitors List",
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            "Terms and Conditions Apllied.",
                            style: TextStyle(color: Colors.white, fontSize: 15),
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
