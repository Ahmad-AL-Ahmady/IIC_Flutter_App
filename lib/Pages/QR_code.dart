import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/Pages/dashboard.dart';
import 'package:login_app/Pages/globels.dart';
import 'package:login_app/Pages//ResetPassword/resetpassotp.dart';
import 'package:login_app/UI/custom_text_field.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  Image? image;

  @override
  void initState() {
    super.initState();
    Generate_qrcode();
  }

  Future<void> Generate_qrcode() async {
    var response = await http.post(
        Uri.https('iic-delivery.mybluemix.net', '/qr/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': await getStringValuesSF()
        },
        body: jsonEncode({}));

    var data = response.body;

    print("======================");
    print(data);
    var awm = Image.memory(base64Decode(data));
    if (response.statusCode == 200) {
      setState(() {
        image = awm;
      });
    } else {
      print("ERROR");
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Code",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', "");
          },
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('Back'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
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
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "1.Send a screenshot of the QR code to admit the visitor",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            "2.The QR code can only be used once",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          child: Center(
                            child: image,
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
    );
  }
}
