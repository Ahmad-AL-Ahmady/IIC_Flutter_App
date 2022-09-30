import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/Pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VisitorList extends StatefulWidget {
  const VisitorList({Key? key}) : super(key: key);

  @override
  State<VisitorList> createState() => _VisitorListState();
}

class _VisitorListState extends State<VisitorList> {
  List<Widget> tilelist = [];
  // var visitorsData;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  Future<String> getVisitorsList() async {
    var response = await http.get(
        Uri.https('iic-project.herokuapp.com', '/api/v1/visitorsList'),
        headers: {
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
                trailing: Text(data[i]["signOut"].substring(0, 10)),
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
    // TODO: implement initState
    super.initState();

    getVisitorsList().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "قائمة الزوار",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 144, 201),
        automaticallyImplyLeading: false,
        leadingWidth: 200,
        elevation: 0,
        leading: ElevatedButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', "");
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
                      child: Column(children: tilelist),
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
