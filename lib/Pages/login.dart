// ignore_for_file: deprecated_member_use

//import 'dart:ffi';
//import 'dart:js';
import 'package:login_app/Pages/dashboard.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'resetpassword.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Pages/resetpassword.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'globels.dart' as globels;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future<String> LOGIN(String email, String password) async {
  var response = await http.post(
      Uri.https('iic-simple-toolchain-20220912122755303.mybluemix.net',
          '/api/v1/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"email": email, "password": password}));
  print(email);
  print(password);
  var token = response.body;

  print("======================");
  print(token); // THIS IS THE TOKEN

  if (response.statusCode == 200) {
    await addStringToSF(token);
    return response.body;
  } else {
    return 'failure';
  }
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
          "Log In Page",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 2, 47, 98),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('Back'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
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
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 0, 43, 91),
                        Color.fromARGB(255, 43, 72, 101),
                        Color.fromARGB(255, 37, 109, 133),
                        Color.fromARGB(255, 143, 227, 207),
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
                          "Welcome To IIC",
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
                          label: "Email",
                          type: TextInputType.streetAddress,
                          hint: "Enter Email",
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          validation: (String? value) {
                            var reg3 = RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                            if (value == null ||
                                value.isEmpty ||
                                !reg3.hasMatch(value)) {
                              return 'Please enter a valid email';
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
                                child: Text("Forget Password !",
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
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                primary: Color(0xff3c6970),
                                padding: EdgeInsets.all(30),
                              ),
                              child: _isloading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 24,
                                        ),
                                        Text("Please Wait")
                                      ],
                                    )
                                  : Text("Login"),
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
                                  } else {
                                    print(result);
                                    setState(() => _isloading = false);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard()));
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
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Text(
                              "Terms and Conditions Apllied.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
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
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
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
                return 'Please enter a valid password';
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
                hintText: "Enter Password",
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildRememberassword() {
    return Container(
      height: 20,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: rememberpwd,
              checkColor: Colors.blueGrey,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  rememberpwd = value!;
                });
              },
            ),
          ),
          Text(
            "Remember me",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

Widget buildLoginButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25),
    child: Container(
      width: 250,
      child: RaisedButton(
        onPressed: () {},
        splashColor: Colors.white,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Color(0xff3c6970),
        padding: EdgeInsets.all(30),
        child: Text(
          "Login",
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget buildForgetPassword() {
  return Container(
    alignment: Alignment.centerRight,
    child: TextButton(
      child: Text("Forget Password !",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      onPressed: () {},
    ),
  );
}
