// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:login_app/Pages/login.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Registrationfinal extends StatefulWidget {
  final String phone;
  final String? token;
  const Registrationfinal({Key? key, required this.phone, required this.token})
      : super(key: key);

  @override
  State<Registrationfinal> createState() =>
      _RegistrationfinalState(phone, token);
}

Future<String> RegisterUserData(String username, String email, String password,
    String phone, String _token) async {
  var response = await http.post(
      Uri.https('iic-project.herokuapp.com', '/api/v1/register/registerUser'),
      headers: {'Content-Type': 'application/json', 'Authorization': _token},
      body: jsonEncode({
        "phone": phone,
        "username": username,
        "email": email,
        "password": password
      }));

  var token = response.body;

  print("======================");
  print(token);

  if (response.statusCode == 200) {
    return 'success';
  } else {
    return "failure";
  }
}

class _RegistrationfinalState extends State<Registrationfinal> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isloading = false;
  var phone;
  var token;

  _RegistrationfinalState(phoneInput, tokenInput) {
    this.phone = phoneInput;
    this.token = tokenInput;
  }
  void ShowMessagereg(BuildContext context) {
    final alert = AlertDialog(
      title: Text("حدث خطأ"),
      content: Text("من فضلك تأكد من النماذج التي ملأتها"),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _finalregisterkey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "التسجيل",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
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
            key: _finalregisterkey,
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
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              "املأ النماذج النصية حتى تتم التسجيل",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            label: "الاسم",
                            type: TextInputType.name,
                            hint: "من فضلك ادخل اسمك",
                            prefixIcon: Icon(
                              Icons.face,
                            ),
                            controler: _name,
                            validation: (String? value) {
                              var reg2 =
                                  RegExp(r'^[a-zA-Z][a-zA-Z]*[ ]*[a-zA-Z]*');
                              if (value == null ||
                                  value.isEmpty ||
                                  !reg2.hasMatch(value)) {
                                return "من فضلك ادخل اسم صحيح";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            label: "بريد الكتروني",
                            type: TextInputType.streetAddress,
                            hint: "ادخل بريدك الالكتروني",
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            controler: _email,
                            validation: (String? value) {
                              var reg3 = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                              if (value == null ||
                                  value.isEmpty ||
                                  !reg3.hasMatch(value)) {
                                return 'من فضلك ادخل بريد الكتروني صحيح';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            label: "كلمة السر",
                            type: TextInputType.visiblePassword,
                            hint: "ادخل كلمة السر",
                            prefixIcon: Icon(
                              Icons.vpn_key,
                            ),
                            controler: _pass,
                            validation: (String? value) {
                              var reg4 = RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                              if (value == null ||
                                  value.isEmpty ||
                                  !reg4.hasMatch(value)) {
                                return 'من فضلك ادخل كلمة سر صحيحة';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            label: "تأكيد كلمة السر",
                            type: TextInputType.visiblePassword,
                            hint: "اعد كتابة كلمة السر صحيحة",
                            prefixIcon: Icon(
                              Icons.vpn_key,
                            ),
                            validation: (String? value) {
                              var reg5 = RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                              if (value == null ||
                                  value.isEmpty ||
                                  !reg5.hasMatch(value) ||
                                  value != _pass.text) {
                                return 'من فضلك ادخل كلمة سر صحيحة';
                              } else {
                                return null;
                              }
                            },
                          ),
                          Text(
                            "ملحوظة: كلمة السر يجب ان تحتوي على ارقام و حرف كبير و حرف صغير على الاقل و رمز",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
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
                                        "استمرار",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color:
                                                Color.fromARGB(255, 35, 39, 66),
                                            fontWeight: FontWeight.bold),
                                      ),
                                onPressed: () async {
                                  if (_finalregisterkey.currentState!
                                      .validate()) {
                                    // TODO: register the user data
                                    var token2 = await RegisterUserData(
                                        _name.text,
                                        _email.text,
                                        _pass.text,
                                        this.phone,
                                        this.token);

                                    if (token2 == 'success') {
                                      setState(() => _isloading = true);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                      setState(() => _isloading = false);
                                    } else {
                                      print('failure login screen');
                                      ShowMessagereg(context);
                                      setState(() => _isloading = false);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
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
}
