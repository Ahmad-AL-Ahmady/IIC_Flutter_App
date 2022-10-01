// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class Violations extends StatefulWidget {
  const Violations({Key? key}) : super(key: key);

  @override
  State<Violations> createState() => _ViolationsState();
}

class _ViolationsState extends State<Violations> {
  final violation = TextEditingController();
  final unitCode = TextEditingController();
  final List<String> items = [
    "مخالفة بناء",
    "مخالفة صيانة ممتلكات",
    "مخالفة سكن",
    "مخالفة منطقة عامة",
    "مخالفات اخرى",
  ];
  String value = "مخالفة بناء";
  void ShowMessage(BuildContext context) {
    Random random = new Random();
    late int randomNumber = random.nextInt(999999);
    final alert = AlertDialog(
      title: Text("تم الابلاغ"),
      content: Text("تم الابلاغ عن مخالفة و رقم المخالفة ($randomNumber)"),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> reportViolation(
      String _description, String _category, String _unitCode) async {
    var response = await http.post(
        Uri.https('iic-project.herokuapp.com', '/api/v1/reportViolation'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': await getStringValuesSF()
        },
        body: jsonEncode({
          "description": _description,
          "category": _category,
          "unitCode": _unitCode
        }));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'failure';
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> violationKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard())),
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
            key: violationKey,
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
                              height: 50,
                            ),
                            Center(
                                child: Text(
                              "ابلغ عن المخالفة",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 300,
                              margin: EdgeInsets.all(16),
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: value,
                                  iconSize: 36,
                                  hint: Text(
                                    "اختر المخالفة",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 166, 163, 163),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  items: items.map(buildMenuItem).toList(),
                                  onChanged: (inp) =>
                                      setState(() => value = inp!),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "المخالفة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 100,
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
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "من فضلك اكتب وصف المخالفة";
                                      } else {
                                        return null;
                                      }
                                    },
                                    minLines: 1,
                                    maxLines: 10,
                                    controller: violation,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(15),
                                        hintText: "اكتب وصف المخالفة هنا",
                                        hintStyle:
                                            TextStyle(color: Colors.black38)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            CustomTextField(
                              label: "رقم الوحدة",
                              type: TextInputType.streetAddress,
                              controler: unitCode,
                              hint: "ادخل رقم الوحدة",
                              prefixIcon: Icon(Icons.home),
                              validation: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "من فضلك ادخل رقم وحدة صحيح";
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
                                    if (violationKey.currentState!.validate()) {
                                      String result = await reportViolation(
                                          violation.text, value, unitCode.text);
                                      if (result == "failure") {
                                        print("Error");
                                        return;
                                      } else {
                                        print('Done');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Dashboard()));
                                        ShowMessage(context);
                                      }
                                    }
                                  },
                                  splashColor: Colors.white,
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(30),
                                  child: Text(
                                    "إبلاغ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 35, 39, 66),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
}
