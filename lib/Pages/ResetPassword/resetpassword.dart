import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:login_app/Pages/login.dart';
import 'dart:convert';
import 'package:login_app/Pages/homepage.dart';
import 'package:http/http.dart' as http;
import 'resetpassotp.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({
    Key? key,
  }) : super(key: key);

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  bool rememberpwd = false;
  bool sec = true;
  final unitnum = TextEditingController();
  final phonenum = TextEditingController();
  var visable = Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );

  Future<String> Forgetpass(String phone, String unitnumber) async {
    var response = await http.post(
        Uri.https('iic-simple-toolchain-20220912122755303.mybluemix.net',
            '/api/v1/forgotPassword/unitAndPhone'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"phone": phone, "unitNumber": unitnumber}));
    print(phone);
    print(unitnumber);
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

  void ShowMessage(BuildContext context) {
    final alert = AlertDialog(
      title: Text("Error"),
      content: Text("Invalid Phone or Unit Number"),
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
    GlobalKey<FormState> resetpass = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
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
                            "Fill in the form to reset Your Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controler: phonenum,
                            label: "Phone Number",
                            type: TextInputType.phone,
                            hint: "Enter your phone number",
                            prefixIcon: Icon(Icons.phone),
                            validation: (String? value) {
                              var reg = RegExp(r'^01[0125][0-9]{8}$');
                              if (value == null ||
                                  value.isEmpty ||
                                  !reg.hasMatch(value)) {
                                return "Please enter correct phone number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controler: unitnum,
                            label: "Unit Number",
                            type: TextInputType.streetAddress,
                            hint: "Enter Your Unit Number",
                            prefixIcon: Icon(Icons.home),
                            validation: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "please enter a valid unit number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Container(
                              width: 250,
                              child: RaisedButton(
                                onPressed: () async {
                                  if (resetpass.currentState!.validate()) {
                                    String phone1 = phonenum.text;
                                    String unit1 = unitnum.text;
                                    var result =
                                        await Forgetpass(phone1, unit1);
                                    if (result == 'failure') {
                                      print('login failed');
                                      ShowMessage(context);
                                    } else {
                                      print(result);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OtpScreen(phone: phone1),
                                        ),
                                      );
                                    }
                                    ;
                                  }
                                },
                                splashColor: Colors.white,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: Color.fromARGB(255, 34, 141, 203),
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
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
