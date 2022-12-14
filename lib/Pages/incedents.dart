// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class Incedents extends StatefulWidget {
  const Incedents({Key? key}) : super(key: key);

  @override
  State<Incedents> createState() => _IncedentsState();
}

void ShowMessage(BuildContext context) {
  Random random = new Random();
  late int randomNumber = random.nextInt(999999);
  final alert = AlertDialog(
    title: Text("تم"),
    content: Text("تم البلاغ عن حادث و رقم البلاغ ($randomNumber)"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> ReortIncident(String _description) async {
  var response = await http.post(
    Uri.https('iic-v6.herokuapp.com', '/api/v1/reportIncident'),
    headers: {
      'Content-Type': 'application/json',
      'authorization': await getStringValuesSF()
    },
    body: jsonEncode(
      {
        "description": _description,
      },
    ),
  );

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

class _IncedentsState extends State<Incedents> {
  final incedent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> inc = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
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
            key: inc,
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
                              "ابلغ عن حادث",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            )),
                            SizedBox(
                              height: 60,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "الحادث",
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
                                    minLines: 1,
                                    maxLines: 10,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "من فضلك اكتب تفاصيل الحادث";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: incedent,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(15),
                                        hintText: "اكتب تفاصيل الحادث هنا",
                                        hintStyle:
                                            TextStyle(color: Colors.black38)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: Container(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (inc.currentState!.validate()) {
                                      String Description = incedent.text;
                                      var result =
                                          await ReortIncident(Description);
                                      if (result == 'failure') {
                                        print('Reporting Failed');
                                      } else {
                                        print(result);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Dashboard(),
                                          ),
                                        );
                                        ShowMessage(context);
                                      }
                                      ;
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    primary: Colors.white,
                                    padding: const EdgeInsets.all(30),
                                  ),
                                  child: const Text(
                                    "ابلغ",
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
}
