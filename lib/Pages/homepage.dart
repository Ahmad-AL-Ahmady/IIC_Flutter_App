// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Pages/Registration/registration.dart';
import 'login.dart';

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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                            "assets/New logo2.png",
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            "?????????? ???? ???? IIC",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Text(
                            "?????????? ?????????? ?????????????????? ?????? ?????? ??????????",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Container(
                              width: 250,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  primary: Colors.white,
                                  padding: const EdgeInsets.all(30),
                                ),
                                child: const Text(
                                  "?????????? ????????????",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 35, 39, 66),
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
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Registration()));
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  primary: Colors.white,
                                  padding: const EdgeInsets.all(30),
                                ),
                                child: const Text(
                                  "?????????????? ???????? ??????",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 35, 39, 66),
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
      ),
    );
  }
}
