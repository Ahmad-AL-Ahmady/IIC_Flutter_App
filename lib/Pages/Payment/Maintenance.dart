import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:login_app/Pages/Payment.dart';
import 'package:login_app/Pages/dashboard.dart';
import 'dart:math';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

void ShowMessage(BuildContext context) {
  Random random = new Random();
  late int randomNumber = random.nextInt(999999);
  final alert = AlertDialog(
    title: Text("Done"),
    content: Text("Mintenance Paid"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> PayMaintenance() async {
  var response = await http.post(
    Uri.https('iic-delivery.mybluemix.net', '/api/v1/payMaintenance'),
    headers: {
      'Content-Type': 'application/json',
      'authorization': await getStringValuesSF()
    },
    body: jsonEncode(
      {},
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

class _MaintenanceState extends State<Maintenance> {
  final amount = TextEditingController();
  TextEditingController credit = TextEditingController();
  final CVV = TextEditingController();
  final ExpDate = TextEditingController();
  final nameOnCard = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> MaintenanceKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Maintenance",
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
          key: MaintenanceKey,
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
                              "Maintenance",
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CVV",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  controller: CVV,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14, bottom: 14),
                                      hintText: 'CVV',
                                      prefixIcon: Icon(Icons.credit_card),
                                      hintStyle:
                                          TextStyle(color: Colors.black38)),
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            label: 'Expiry Date',
                            type: TextInputType.datetime,
                            controler: ExpDate,
                            hint: "Enter Expiry Date",
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomTextField(
                            label: 'Name on Card',
                            type: TextInputType.name,
                            controler: nameOnCard,
                            hint: 'Enter Name On Card',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: SizedBox(
                              width: 250,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (MaintenanceKey.currentState!.validate()) {
                                    var result = await PayMaintenance();
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
