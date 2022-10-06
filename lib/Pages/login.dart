// ignore_for_file: deprecated_member_use

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:login_app/Pages/ResetPassword/resetpassword.dart';
import 'package:login_app/Pages/dashboard.dart';
import 'package:login_app/Pages/homepage.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future<String> LOGIN(String email, String password) async {
  String? fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fcmToken", fcmToken);
  }

  var response = await http.post(
      Uri.https('iic-v6.herokuapp.com', '/api/v1/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {"email": email, "password": password, "fcmToken": fcmToken}));

  print("EMAIL: $email");
  print("Password: $password");
  var token = response.body;

  print("======================");
  print(token); // THIS IS THE TOKEN
  print("FCMTOKEN: $fcmToken");

  if (response.statusCode == 200) {
    await addStringToSF(token);
    return response.body;
  } else {
    return 'failure';
  }
}

void ShowMessage(BuildContext context) {
  final alert = AlertDialog(
    title: Text("حدث خطأ"),
    content: Text("البريد الإلكتروني أو كلمة السر خاطئة"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

addStringToSF(String token2) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token2);
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isloading = false;
  bool rememberpwd = false;
  bool sec = true;
  final _user = TextEditingController();
  final _pass = TextEditingController();
  var visable = Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _loginkey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تسجيل الدخول",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => homepage())),
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('الرجوع'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Form(
            key: _loginkey,
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
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            "مرحبا بك في IIC",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controler: _user,
                            label: "البريد الالكتروني",
                            type: TextInputType.streetAddress,
                            hint: "ادخل بريدك الالكتروني",
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            validation: (String? value) {
                              var reg3 = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                              if (value == null ||
                                  value.isEmpty ||
                                  !reg3.hasMatch(value)) {
                                return 'من فضلك ادخل بريد الكتروني صحيح بدون مسافات';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          buildPassword(),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text("نسيت كلمة السر ؟",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Resetpassword()));
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Container(
                              width: 250,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  primary: Color.fromARGB(255, 255, 255, 255),
                                  padding: EdgeInsets.all(30),
                                ),
                                child: _isloading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color:
                                                Color.fromARGB(255, 35, 39, 66),
                                          ),
                                          SizedBox(
                                            width: 24,
                                          ),
                                          Text(
                                            "من فضلك انتظر",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 35, 39, 66),
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    : Text(
                                        "الدخول",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color:
                                                Color.fromARGB(255, 35, 39, 66),
                                            fontWeight: FontWeight.bold),
                                      ),
                                onPressed: () async {
                                  if (_loginkey.currentState!.validate()) {
                                    String username1 = _user.text;
                                    String password1 = _pass.text;
                                    setState(() => _isloading = true);
                                    var result =
                                        await LOGIN(username1, password1);
                                    if (result == 'failure') {
                                      print('login failed');
                                      setState(() => _isloading = false);
                                      ShowMessage(context);
                                    } else {
                                      print(result);
                                      setState(() => _isloading = false);
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dashboard()),
                                          (route) => route.isFirst);
                                    }
                                  }
                                  ;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 10,
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
      ),
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "كلمة السر",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xffebefff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          height: 60,
          child: TextFormField(
            validator: (String? value) {
              var reg4 = RegExp(
                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
              if (value == null || value.isEmpty || !reg4.hasMatch(value)) {
                return 'من فضلك ادخل كلمة سر صحيحة';
              } else {
                return null;
              }
            },
            controller: _pass,
            obscureText: sec,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      sec = !sec;
                    });
                  },
                  icon: sec ? visableoff : visable,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: Color(0xff4c5166),
                ),
                hintText: "ادخل كلمة السر",
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }
}
