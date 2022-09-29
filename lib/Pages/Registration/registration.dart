// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'registerationotp.dart';
import 'package:login_app/UI/custom_text_field.dart';

// ignore: must_be_immutable
class Registration extends StatefulWidget {
  bool rememberpwd = false;
  bool _isloading = false;
  bool sec = true;
  var visable = const Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = const Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );

  Registration({Key? key}) : super(key: key);
  @override
  State<Registration> createState() => _RegistrationState();
}

Future<String> Register(String Phone, String UnitNumber) async {
  var response = await http.post(
      Uri.https('iic-project.herokuapp.com', '/api/v1/register/unitAndPhone'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "phone": Phone,
        "unitNumber": UnitNumber,
      }));
  print(Phone);
  print(UnitNumber);
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
    title: Text("خطأ"),
    content: Text("رقم هاتف او وحدة خاطئ من فضبلك اعد المحاول"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _RegistrationState extends State<Registration> {
  bool rememberpwd = false;
  bool sec = true;
  bool _isloading = false;
  final phone = TextEditingController();
  final unitnumber = TextEditingController();

  var visable = const Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = const Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );

  test() {
    print("Hello");
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formkey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "صفحة التسجيل",
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
            key: _formkey,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
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
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const Center(
                              child: Text(
                            textAlign: TextAlign.center,
                            "املأ النماذج حتى تسجل حسابك لأول مرة ",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "رقم الهاتف",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 62,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: const Color(0xffebefff),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                      )
                                    ]),
                                child: TextFormField(
                                  controller: phone,
                                  validator: (String? value) {
                                    var reg = RegExp(r'^01[0125][0-9]{8}$');
                                    if (value == null ||
                                        value.isEmpty ||
                                        !reg.hasMatch(value)) {
                                      return "ادخل رقم هاتف صحيح";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14, bottom: 14),
                                      prefixIcon: Icon(Icons.phone),
                                      hintText: "ادخل رقم الهاتف  ",
                                      hintStyle:
                                          TextStyle(color: Colors.black38)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            controler: unitnumber,
                            label: "رقم الوحدة",
                            type: TextInputType.streetAddress,
                            hint: "ادخل رقم الوحدة",
                            prefixIcon: Icon(
                              Icons.home,
                            ),
                            validation: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "ادخل رقم وحدة صحيح";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
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
                                  primary: Color.fromARGB(255, 34, 141, 203),
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
                                          Text("من فضلك انتظر")
                                        ],
                                      )
                                    : Text("استمرار"),
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    String phone1 = phone.text;
                                    String unitnumber1 = unitnumber.text;
                                    setState(() => _isloading = true);
                                    var statues =
                                        await Register(phone1, unitnumber1);
                                    if (statues == 'failure') {
                                      print('Registration Failed');
                                      setState(() => _isloading = false);
                                      ShowMessage(context);
                                    } else {
                                      print(statues);
                                      setState(() => _isloading = false);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationOtp(
                                                      phone: phone1)));
                                    }
                                  }
                                  ;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
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
