import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'ResetPassword2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState(phone);
}

Future<String> OtpReset(String Otp, String phone) async {
  var response = await http.post(
      Uri.https('iic-v3.herokuapp.com', '/api/v1/forgotPassword/validateOtp'),
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
    title: Text("حدث خطأ"),
    content: Text("خاطئ OTP"),
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
  bool _isloading = false;

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
            key: _otpkey,
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
                                "اكتب الرمز الذي استلمته",
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
                              hint: "ادخل الرمز هنا",
                              prefixIcon: Icon(Icons.security),
                              validation: (String? value) {
                                var reg = RegExp(r'^[0-9]{6}');
                                if (value == null ||
                                    value.isEmpty ||
                                    !reg.hasMatch(value)) {
                                  return "من فضلك ادخل الكود بشكل صحيح";
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
                                          "الاستمرار",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 35, 39, 66),
                                              fontWeight: FontWeight.bold),
                                        ),
                                  onPressed: () async {
                                    if (_otpkey.currentState!.validate()) {
                                      String otp1 = otp.text;
                                      setState(() => _isloading = true);
                                      var statues = await OtpReset(otp1, phone);
                                      if (statues == 'failure') {
                                        print('Registration Failed');
                                        setState(() => _isloading = false);
                                        ShowMessage(context);
                                      } else {
                                        print(statues);
                                        print(statues);
                                        setState(() => _isloading = false);
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
      ),
    );
  }
}
