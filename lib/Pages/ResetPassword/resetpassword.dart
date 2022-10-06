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
        Uri.https(
            'iic-v6.herokuapp.com', '/api/v1/forgotPassword/unitAndPhone'),
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
      title: Text("حدث خطـأ"),
      content: Text("رقم الهاتف أو الوحدة غير صحيح"),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool _isloading = false;
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
                              "املأ النماذج النصية لإعادة تعيين كلمة السر الخاصة بك",
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
                              label: "رقم الهاتف",
                              type: TextInputType.phone,
                              hint: "ادخل رقم هاتفك",
                              prefixIcon: Icon(Icons.phone),
                              validation: (String? value) {
                                var reg = RegExp(r'^01[0125][0-9]{8}$');
                                if (value == null ||
                                    value.isEmpty ||
                                    !reg.hasMatch(value)) {
                                  return "من فضلك ادخل رقم هاتف صحيح";
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
                              label: "رقم الوحدة",
                              type: TextInputType.streetAddress,
                              hint: "ادخل رقم الوحدة",
                              prefixIcon: Icon(Icons.home),
                              validation: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "من فضلك ادخل رقم الوحدة الصحيح";
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
                                      String phone1 = phonenum.text;
                                      String unit1 = unitnum.text;
                                      setState(() => _isloading = true);
                                      var result =
                                          await Forgetpass(phone1, unit1);
                                      if (result == 'failure') {
                                        print('login failed');
                                        setState(() => _isloading = false);
                                        ShowMessage(context);
                                      } else {
                                        print(result);
                                        setState(() => _isloading = false);
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
