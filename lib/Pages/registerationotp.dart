import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'registration2.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:otp_text_field/otp_text_field.dart';

class RegistrationOtp extends StatefulWidget {
  final String phone;
  const RegistrationOtp({Key? key, required this.phone}) : super(key: key);

  @override
  State<RegistrationOtp> createState() => _RegistrationOtpState(phone);
}

Future<String> OtpRegister(String Otp, String phone) async {
  var response = await http.post(
      Uri.https('iic-simple-toolchain-20220912122755303.mybluemix.net',
          '/api/v1/register/validateOTP'),
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

class _RegistrationOtpState extends State<RegistrationOtp> {
  var phone;

  _RegistrationOtpState(phoneInput) {
    this.phone = phoneInput;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _otpkey = GlobalKey();
    bool loading = false;
    final otp = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration",
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
                              return "please enter the otp";
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
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                primary: Color(0xff3c6970),
                                padding: EdgeInsets.all(30),
                              ),
                              child: loading
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
                                  : Text("Confirm"),
                              onPressed: () async {
                                if (_otpkey.currentState!.validate()) {
                                  String otp1 = otp.text;
                                  setState(() => loading = true);
                                  var statues = await OtpRegister(otp1, phone);
                                  if (statues == 'failure') {
                                    print('Registration Failed');
                                    setState(() => loading = false);
                                  } else {
                                    print(statues);
                                    setState(() => loading = false);
                                    print(statues);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Registrationfinal(
                                                    phone: phone,
                                                    token: statues)));
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
}
