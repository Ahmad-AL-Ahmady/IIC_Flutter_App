// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:login_app/Pages/login.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class resetpasswordfinal extends StatefulWidget {
  final String phone;
  final String? token;
  const resetpasswordfinal({Key? key, required this.phone, required this.token})
      : super(key: key);

  @override
  State<resetpasswordfinal> createState() =>
      _resetpasswordfinalState(phone, token);
}

void ShowMessagePass(BuildContext context) {
  final alert = AlertDialog(
    title: Text("حدث خطأ"),
    content: Text("حدث خطأ ما اعد المحاولة مرة اخرى"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> ResetPassFinal(
    String password, String phone, String _token) async {
  var response = await http.post(
      Uri.https(
          'iic-project.herokuapp.com', '/api/v1/forgotPassword/resetPassword'),
      headers: {'Content-Type': 'application/json', 'Authorization': _token},
      body: jsonEncode({"phone": phone, "password": password}));

  var token = response.body;

  print("======================");
  print(token);

  if (response.statusCode == 200) {
    return 'success';
  } else {
    return "failure";
  }
}

class _resetpasswordfinalState extends State<resetpasswordfinal> {
  final _pass = TextEditingController();
  var phone;
  bool _isloading = false;
  var token;
  final password = TextEditingController();
  _resetpasswordfinalState(phoneInput, tokenInput) {
    this.phone = phoneInput;
    this.token = tokenInput;
  }
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> resetpass = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          "اعادة تعيين كلمة السر",
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
            key: resetpass,
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
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                                child: Text(
                              "املأ النموذج لاعادة تعيين كلمة السر",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controler: password,
                              label: "كلمة السر الجديدة",
                              type: TextInputType.visiblePassword,
                              hint: "ادخل كلمة السر الجديدة",
                              prefixIcon: Icon(Icons.vpn_key),
                              validation: (String? value) {
                                var reg4 = RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                                if (value == null ||
                                    value.isEmpty ||
                                    !reg4.hasMatch(value)) {
                                  return 'من فضلك ادخل كرمة سر صحيحة';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              label: "تأكيد كلمة المرور",
                              type: TextInputType.visiblePassword,
                              hint: "ادخل كلمة السر الجديدة مجددا",
                              prefixIcon: Icon(Icons.vpn_key),
                              validation: (String? value) {
                                var reg5 = RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                                if (value == null ||
                                    value.isEmpty ||
                                    !reg5.hasMatch(value) ||
                                    value != password.text) {
                                  return 'من فضلك ادخل كرمة سر صحيحة';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Text(
                                " كلمة السر يجب ان تحتوي على ارقام و حرف كبير و حرف صغير على الاقل و رمز",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                                              color: Color.fromARGB(
                                                  255, 35, 39, 66),
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
                                          "تعيين كلمة المرور",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 35, 39, 66),
                                              fontWeight: FontWeight.bold),
                                        ),
                                  onPressed: () async {
                                    if (resetpass.currentState!.validate()) {
                                      setState(() => _isloading = true);
                                      var token2 = await ResetPassFinal(
                                          password.text,
                                          this.phone,
                                          this.token);
                                      if (token2 == 'success') {
                                        setState(() => _isloading = false);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      } else {
                                        setState(() => _isloading = false);
                                        print('failure login screen');
                                        ShowMessage(context);
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
      ),
    );
  }
}
