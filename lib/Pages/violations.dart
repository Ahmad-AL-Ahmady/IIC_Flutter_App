// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/UI/dropdownlist.dart';
import 'package:login_app/UI/custom_text_field.dart';

import 'dashboard.dart';

class Violations extends StatefulWidget {
  const Violations({Key? key}) : super(key: key);

  @override
  State<Violations> createState() => _ViolationsState();
}

class _ViolationsState extends State<Violations> {
  final violation = TextEditingController();
  final unitCode = TextEditingController();
  final items = [
    "Building Violation",
    "Property Maintenance",
    "Housing Violation",
    "Public Area Violation",
    "Other",
  ];
  String? value;
  void ShowMessage(BuildContext context) {
    final alert = AlertDialog(
      title: Text(
        "Done",
        textAlign: TextAlign.center,
      ),
      content: Text("Violation Reported"),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Violations",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 2, 47, 98),
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
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                            child: Text(
                          "Report The Violation",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
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
                                  color: Color.fromARGB(255, 166, 163, 163)),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              items: items.map(buildMenuItem).toList(),
                              onChanged: (value) =>
                                  setState(() => this.value = value),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Violation",
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
                                controller: violation,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(15),
                                    hintText: "Enter the Violation here",
                                    hintStyle:
                                        TextStyle(color: Colors.black38)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextField(
                          label: "Unit code",
                          type: TextInputType.streetAddress,
                          controler: unitCode,
                          hint: "Enter Unit Code Of who did it",
                          prefixIcon: Icon(Icons.home),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()));
                                ShowMessage(context);
                              },
                              splashColor: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Color(0xff3c6970),
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Report",
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
