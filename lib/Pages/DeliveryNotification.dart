// ignore: file_names
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:login_app/Pages/dashboard.dart';

class DeliveryResponse extends StatefulWidget {
  final String? orderId;
  const DeliveryResponse({Key? key, this.orderId}) : super(key: key);

  @override
  State<DeliveryResponse> createState() => _DeliveryResponseState(this.orderId);
}

void ShowMessageYes(BuildContext context) {
  final alert = AlertDialog(
    title: Text("تم"),
    content: Text("عامل التوصيل في الطريق اليك"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void ShowMessageNo(BuildContext context) {
  final alert = AlertDialog(
    title: Text("تم"),
    content: Text("تم رفض الطلب"),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> Response(String _res, String order) async {
  var response = await http.post(
    Uri.https('iic-project.herokuapp.com', '/api/v1/respondToDelivery'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      {
        "response": _res,
        "orderId": order,
      },
    ),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'failure';
  }
}

class _DeliveryResponseState extends State<DeliveryResponse> {
  String orderId = "";

  _DeliveryResponseState(orderId) {
    this.orderId = orderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "لديك طلب توصيل",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Form(
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
                              height: 100,
                            ),
                            Center(
                              child: Text(
                                "لديك طلبية في انظارك هل تريد القبول ؟",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 250,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String No = "no";
                                        var result =
                                            await Response(No, orderId);
                                        if (result == 'failure') {
                                          print('Reporting Failed');
                                          print(orderId);
                                        } else {
                                          print(result);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (gcontext) =>
                                                      Dashboard()));
                                          ShowMessageNo(context);
                                        }
                                        ;
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        primary:
                                            Color.fromARGB(255, 34, 141, 203),
                                        padding: const EdgeInsets.all(30),
                                      ),
                                      child: const Text(
                                        "لا",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String Yes = "yes";
                                        var result =
                                            await Response(Yes, orderId);
                                        if (result == 'failure') {
                                          print('Reporting Failed');
                                          print(orderId);
                                        } else {
                                          print(result);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (gcontext) =>
                                                      Dashboard()));
                                          ShowMessageYes(context);
                                          ;
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        primary:
                                            Color.fromARGB(255, 34, 141, 203),
                                        padding: const EdgeInsets.all(30),
                                      ),
                                      child: const Text(
                                        "نعم",
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
