import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ownersCars extends StatefulWidget {
  const ownersCars({Key? key}) : super(key: key);

  @override
  State<ownersCars> createState() => _ownersCarsState();
}

class _ownersCarsState extends State<ownersCars> {
  List<Widget> tilelist = [];
  // var visitorsData;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  Future<String> getOwnersCars() async {
    var response = await http
        .get(Uri.https('iic-v6.herokuapp.com', '/api/v1/cars'), headers: {
      'Content-Type': 'application/json',
      'authorization': await getStringValuesSF()
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;

      setState(() {
        for (int i = 0; i < data.length; i++) {
          tilelist.add(Card(
              elevation: 10,
              child: ListTile(
                leading: Text(data[i]["plateNumber"]),
              )));
        }
      });

      print("=======VisitorsList=====");
      print("DATA: $data");
      print("Visitors List: $tilelist");

      return response.body;
    } else {
      return 'failure';
    }
  }

  @override
  void initState() {
    super.initState();

    getOwnersCars().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "سياراتك الخاصة",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_left_sharp),
          label: const Text('الرجوع'),
          style: ElevatedButton.styleFrom(
              elevation: 0, primary: Colors.transparent),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                          children: tilelist.length == 0
                              ? [
                                  SizedBox(
                                    height: 300,
                                  ),
                                  Center(
                                    child: Text(
                                      "ليس لديك سيارات مسجلة",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ]
                              : tilelist),
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
