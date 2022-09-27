import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:login_app/Pages/Payment.dart';
import 'package:login_app/Pages/dashboard.dart';
import 'dart:math';
import 'package:login_app/UI/dropdownlist.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Gardening extends StatefulWidget {
  const Gardening({Key? key}) : super(key: key);

  @override
  State<Gardening> createState() => _GardeningState();
}

void ShowMessage(BuildContext context) {
  Random random = new Random();
  late int randomNumber = random.nextInt(999999);
  final alert = AlertDialog(
    title: Text("Done"),
    content: Text("Gardening Paid"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> PayGardening(int amount) async {
  var response = await http.post(
    Uri.https('iic-delivery.mybluemix.net', '/api/v1/payService'),
    headers: {
      'Content-Type': 'application/json',
      'authorization': await getStringValuesSF()
    },
    body: jsonEncode(
      {
        "amount": amount,
        "service": "Gardening",
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

class _GardeningState extends State<Gardening> {
  final amount = TextEditingController();
  TextEditingController credit = TextEditingController();
  final CVV = TextEditingController();
  final ExpDate = TextEditingController();
  final nameOnCard = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> GardeningKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          "Gardening",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Payment())),
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('Back'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Form(
          key: GardeningKey,
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
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "Gardening",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controler: amount,
                            label: "Amount",
                            type: TextInputType.number,
                            hint: "Enter Your Amount",
                            validation: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter The Amount";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            controler: credit,
                            label: "Credit Card",
                            type: TextInputType.number,
                            hint: "Enter Your Credit Card Number",
                            validation: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter The Credit Card Number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            controler: CVV,
                            label: "CVV",
                            type: TextInputType.number,
                            hint: "Enter Your CVV",
                            prefixIcon: Icon(Icons.credit_card),
                            validation: (String? value) {
                              var reg = RegExp(r'^[0-9]{3}');
                              if (value == null ||
                                  value.isEmpty ||
                                  !reg.hasMatch(value)) {
                                return "Please Enter The CVV";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            controler: ExpDate,
                            label: "Expiry Date",
                            type: TextInputType.datetime,
                            hint: "Enter Your Expiry Date",
                            validation: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter The Expiry Date";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            controler: nameOnCard,
                            label: "Name On Card",
                            type: TextInputType.name,
                            hint: "Enter Your Name",
                            validation: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter The Name On Card";
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
                            child: SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (GardeningKey.currentState!.validate()) {
                                    int _amount = int.parse(amount.text);
                                    var result = await PayGardening(_amount);
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
                                  primary: Color.fromARGB(255, 34, 141, 203),
                                  padding: const EdgeInsets.all(30),
                                ),
                                child: const Text(
                                  "Pay",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
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
}
