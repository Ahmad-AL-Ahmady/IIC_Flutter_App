// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:intl/intl.dart';
import 'package:login_app/Pages/globels.dart';
import 'package:login_app/UI/dropdownlist.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ServiceTicketing extends StatefulWidget {
  const ServiceTicketing({Key? key}) : super(key: key);

  @override
  State<ServiceTicketing> createState() => _ServiceTicketingState();
}

Future<String> Send(String date, String type) async {
  var response = await http.post(
      Uri.https('iic-simple-toolchain-20220912122755303.mybluemix.net',
          '/api/v1/requestService'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': await getStringValuesSF(),
      },
      body: jsonEncode({"serviceType": type, "dateOfRequest": date}));
  print(type);
  print(date);
  var token = response.body;

  print("======================");
  print(token); // THIS IS THE TOKEN

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

void ShowMessage(BuildContext context) {
  Random random = new Random();
  late int randomNumber = random.nextInt(999999);
  final alert = AlertDialog(
    title: Text("Done"),
    content: Text("Service Requested, Refrence Number ($randomNumber)"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _ServiceTicketingState extends State<ServiceTicketing> {
  final List<String> items = ["Electricity", "Plumbing", "Gardening"];
  String value = "Electricity";
  final date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _Service = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Service Ticketing",
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
          label: const Text('Back'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Form(
          key: _Service,
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
                            "Choose The Service You Desire",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
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
                                  "Choose Category",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 166, 163, 163),
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
                          TextFormField(
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                print("null choice");
                                return "please enter a valid date";
                              } else {
                                return null;
                              }
                            },
                            controller: date,
                            decoration: InputDecoration(
                              icon: Icon(Icons.calendar_month_rounded),
                              labelText: "Select a Date",
                            ),
                            onTap: (() async {
                              DateTime? pickeddate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickeddate != null) {
                                setState(
                                  () {
                                    date.text = DateFormat('yyyy-MM-dd')
                                        .format(pickeddate);
                                  },
                                );
                              } else {
                                print('Failure');
                              }
                            }),
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
                                  if (_Service.currentState!.validate()) {
                                    String? _type = value;
                                    String? date1 = date.text;
                                    var result = await Send(date1, _type);
                                    if (result == 'failure') {
                                      print('login failed');
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
                                splashColor: Colors.white,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                color: Color.fromARGB(255, 34, 141, 203),
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  "Request",
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
