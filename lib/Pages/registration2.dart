// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:login_app/UI/custom_text_field.dart';
import 'package:flutter/material.dart';

class Registrationfinal extends StatefulWidget {
  final String phone;
  const Registrationfinal({Key? key, required this.phone}) : super(key: key);

  @override
  State<Registrationfinal> createState() => _RegistrationfinalState();
}

Future<String> RegisterUserData(String username, String email, String password, String phone) async {
  var response = await http.post(
      Uri.https('iic-simple-toolchain-20220912122755303.mybluemix.net',
          '/api/v1/register/registerUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode({
        "phone": phone,
        "username": username,
        "email": email,
        "password": password
      }));
      
  var token = response.body;

  print("======================");
  print(token);

  if (response.statusCode == 200) {
    return 'success';
  } else {
    return;
  }
}

class _RegistrationfinalState extends State<Registrationfinal> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  _RegistrationfinalState( phoneInput) {
    this.phone = phoneInput;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _finalregisterkey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registration",
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
        child: Form(
          key: _finalregisterkey,
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
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "Fill in the form to complete Registration",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          label: "Username",
                          type: TextInputType.name,
                          hint: "Enter Username",
                          prefixIcon: Icon(
                            Icons.face,
                          ),
                          controler: _name,
                          validation: (String? value) {
                            var reg2 = RegExp(r'^[a-zA-Z0-9]+$');
                            if (value == null ||
                                value.isEmpty ||
                                !reg2.hasMatch(value)) {
                              return "Please enter a valid username";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          label: "Email",
                          type: TextInputType.streetAddress,
                          hint: "Enter Email",
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          controler: _email,
                          validation: (String? value) {
                            var reg3 = RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                            if (value == null ||
                                value.isEmpty ||
                                !reg3.hasMatch(value)) {
                              return 'Please enter a valid email';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          label: "Password",
                          type: TextInputType.visiblePassword,
                          hint: "Enter Password",
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          controler: _pass,
                          validation: (String? value) {
                            var reg4 = RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                            if (value == null ||
                                value.isEmpty ||
                                !reg4.hasMatch(value)) {
                              return 'Please enter a valid password';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          label: "Confirm Password",
                          type: TextInputType.visiblePassword,
                          hint: "Confirm Your Password",
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          validation: (String? value) {
                            var reg5 = RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                            if (value == null ||
                                value.isEmpty ||
                                !reg5.hasMatch(value) ||
                                value != _pass.text) {
                              return 'please enter a valid password';
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
                              onPressed: () {
                                if (_finalregisterkey.currentState!
                                    .validate()) {
                                  // TODO: register the user data
                                  var token = RegisterUserData(_name, _email, _pass, this.phone);

                                  if (token == 'success') { // it means there is a token
                                    // navigate to the login
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                login(
                                                    phone: phone1)));
                                  } else {
                                    // TODO: show error
                                  }
                                }
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Color(0xff3c6970),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Register",
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
