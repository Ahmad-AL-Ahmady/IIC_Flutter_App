// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Pages/registerotp.dart';
import 'package:login_app/Pages/registration2.dart';
import 'package:login_app/UI/custom_text_field.dart';

// ignore: must_be_immutable
class Registration extends StatefulWidget {
  bool rememberpwd = false;
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

class _RegistrationState extends State<Registration> {
  bool rememberpwd = false;
  bool sec = true;
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
          "Registration Page",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 47, 98),
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
        child: Form(
          key: _formkey,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color.fromARGB(255, 0, 43, 91),
                        Color.fromARGB(255, 43, 72, 101),
                        const Color.fromARGB(255, 37, 109, 133),
                        const Color.fromARGB(255, 143, 227, 207),
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
                          "Register Your New Account.",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          label: "Phone Number",
                          type: TextInputType.phone,
                          hint: "Enter Phone Number",
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                          validation: (String? value) {
                            var reg = RegExp(r'^01[0125][0-9]{8}$');
                            if (value == null ||
                                value.isEmpty ||
                                !reg.hasMatch(value)) {
                              return "Please enter correct phone number";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          label: "Unit Number",
                          type: TextInputType.streetAddress,
                          hint: "Enter Unit Number",
                          prefixIcon: Icon(
                            Icons.home,
                          ),
                          validation: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "please enter a valid unit number";
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
                            child: RaisedButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterOTP()));
                                }
                                ;
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: const Color(0xff3c6970),
                              padding: const EdgeInsets.all(30),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white),
                            ),
                            child: const Text(
                              "Terms and Conditions Apllied.",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            )),
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
    );
  }
}
