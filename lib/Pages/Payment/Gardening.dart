import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:login_app/Pages/Payment.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:login_app/Pages/dashboard.dart';
import 'dart:math';
import 'package:login_app/UI/dropdownlist.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool servicesNeedsPayment = false;
List<String> services = [];
String value = '';

class Gardening extends StatefulWidget {
  const Gardening({Key? key}) : super(key: key);

  @override
  State<Gardening> createState() => _GardeningState();
}

void ShowMessage(BuildContext context) {
  Random random = new Random();
  late int randomNumber = random.nextInt(999999);
  final alert = AlertDialog(
    title: Text("تم"),
    content: Text("تم دفع خدمة صيانة الحدائق"),
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
    Uri.https('iic-v3.herokuapp.com', '/api/v1/payService'),
    headers: {
      'Content-Type': 'application/json',
      'authorization': await getStringValuesSF()
    },
    body: jsonEncode(
      {
        "amount": amount,
        "service": "صيانة الحدائق",
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
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getStringList("gardening") != null) {
        if (prefs.getStringList("gardening")!.isNotEmpty) {
          setState(() {
            servicesNeedsPayment = true;
            services = prefs.getStringList("gardening")!;
            value = services[0];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> GardeningKey = GlobalKey();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            textAlign: TextAlign.center,
            " ",
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
            label: const Text('الرجوع'),
            style: ElevatedButton.styleFrom(
                elevation: 0, primary: Colors.transparent),
          ),
        ),
        body: servicesNeedsPayment
            ? AnnotatedRegion<SystemUiOverlayStyle>(
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
                                      "صيانة الحدائق",
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
                                          "اخترالخدمة",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 166, 163, 163),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        isExpanded: true,
                                        dropdownColor: Colors.white,
                                        items: services
                                            .map(buildMenuItem)
                                            .toList(),
                                        onChanged: (inp) =>
                                            setState(() => value = inp!),
                                      ),
                                    ),
                                  ),
                                  CustomTextField(
                                    controler: amount,
                                    label: "المبلغ",
                                    type: TextInputType.number,
                                    hint: "ادخل المبلغ",
                                    validation: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "من فضلك ادخل المبلغ المدفوع";
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
                                    label: "البطاقة الائتمانية",
                                    type: TextInputType.number,
                                    hint: "ادخل رقم بطاقتك التأمينية",
                                    validation: (String? value) {
                                      var reg = RegExp(r'^[0-9]{16}$');
                                      if (value == null ||
                                          value.isEmpty ||
                                          !reg.hasMatch(value)) {
                                        return "من فضلك ادخل رقم بطاقتك التأمينية";
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
                                    hint: "اكتب رقم بطاقة تحقيق القيمة",
                                    prefixIcon: Icon(Icons.credit_card),
                                    validation: (String? value) {
                                      var reg = RegExp(r'^[0-9]{3}$');
                                      if (value == null ||
                                          value.isEmpty ||
                                          !reg.hasMatch(value)) {
                                        return "ادخل الرقم الصحيح";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    validation: (String? value) {
                                      final regex = RegExp(
                                          r'^(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})$');
                                      if (value == null ||
                                          value.isEmpty ||
                                          !regex.hasMatch(value)) {
                                        print("null choice");
                                        return "ادخل تاريخ انتهاء صحيح";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controler: ExpDate,
                                    label: "ادخل تاريخ انتهاء صحيح",
                                    type: TextInputType.datetime,
                                    hint: "MM/YY",
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  CustomTextField(
                                    controler: nameOnCard,
                                    label: "الاسم على البطاقة",
                                    type: TextInputType.name,
                                    hint: "اكتب الاسم الموجود على البطاقة",
                                    validation: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "من فضلك ادخل الاسم الصحيح";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: SizedBox(
                                      width: 250,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (GardeningKey.currentState!
                                              .validate()) {
                                            int _amount =
                                                int.parse(amount.text);
                                            var result =
                                                await PayGardening(_amount);
                                            if (result == 'failure') {
                                              print('Reporting Failed');
                                            } else {
                                              print(result);
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              services.remove(value.toString());
                                              await preferences.setStringList(
                                                  'gardening', services);
                                              if (services.isEmpty) {
                                                servicesNeedsPayment = false;
                                              }
                                              Navigator.pop(context);
                                              ShowMessage(context);
                                            }
                                            ;
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          primary: Color.fromARGB(
                                              255, 255, 255, 255),
                                          padding: const EdgeInsets.all(30),
                                        ),
                                        child: const Text(
                                          "إدفع",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 35, 39, 66),
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
              )
            : Center(
                child: const Text("ليس لديك خدمات تقوم بدفعها"),
              ));
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
