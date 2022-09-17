import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'ResetPassword2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState(phone);
}

Future<String> OtpReset(String Otp, String phone) async {
  var response = await http.post(
      Uri.https('iic-simple-toolchain-20220912122755303.mybluemix.net',
          '/api/v1/forgotPassword/validateOtp'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"otp": Otp, "phone": phone}));
  print(Otp);
  print(phone);
  var data = response.body;

  print("======================");
  print(data);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'failure';
  }
}

void ShowMessage(BuildContext context) {
  final alert = AlertDialog(
    title: Text("Error"),
    content: Text("Invalid OTP"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _OtpScreenState extends State<OtpScreen> {
  var phone;

  _OtpScreenState(phoneInput) {
    this.phone = phoneInput;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _otpkey = GlobalKey();
    final otp = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
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
          key: _otpkey,
          child: GestureDetector(
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
                              "Enter the code you Received",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          CustomTextField(
                            controler: otp,
                            label: "OTP",
                            type: TextInputType.number,
                            hint: "Enter the code here",
                            prefixIcon: Icon(Icons.security),
                            validation: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "please enter a valid unit number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: SizedBox(
                              width: 250,
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_otpkey.currentState!.validate()) {
                                    String otp1 = otp.text;
                                    var statues = await OtpReset(otp1, phone);
                                    if (statues == 'failure') {
                                      print('Registration Failed');
                                      ShowMessage(context);
                                    } else {
                                      print(statues);
                                      print(statues);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  resetpasswordfinal(
                                                      phone: phone,
                                                      token: statues)));
                                    }
                                  }
                                  ;
                                },
                                splashColor: Colors.white,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: const Color(0xff3c6970),
                                padding: const EdgeInsets.all(30),
                                child: const Text(
                                  "Confirm",
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
                          Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text(
                                "Terms and Conditions Apllied.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
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
      ),
    );
  }
}
