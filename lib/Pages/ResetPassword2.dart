// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:flutter/material.dart';

class resetpasswordfinal extends StatelessWidget {
  const resetpasswordfinal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 2, 47, 98),
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
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
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 0, 43, 91),
                        Color.fromARGB(255, 43, 72, 101),
                        Color.fromARGB(255, 37, 109, 133),
                        Color.fromARGB(255, 143, 227, 207),
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
                          "Fill in the form to reset Your Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          label: "New Password",
                          type: TextInputType.visiblePassword,
                          hint: "Enter your Password",
                          prefixIcon: Icon(Icons.vpn_key),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                            label: "Confirm Password",
                            type: TextInputType.visiblePassword,
                            hint: "Confirm Your Password",
                            prefixIcon: Icon(Icons.vpn_key)),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            width: 250,
                            child: RaisedButton(
                              onPressed: () {},
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Color(0xff3c6970),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Reset Password",
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
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            "Terms and Conditions Apllied.",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
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
    );
  }
}
