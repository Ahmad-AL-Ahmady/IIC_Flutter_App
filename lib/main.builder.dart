import 'package:flutter/material.dart';
import 'package:login_app/Pages/dashboard.dart';
import 'package:login_app/Pages/homepage.dart';
import 'package:login_app/splash.page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBuilder extends StatefulWidget {
  @override
  State<MainBuilder> createState() => _MainBuilderState();
}

class _MainBuilderState extends State<MainBuilder> {
  SharedPreferences? sharedPreferences;
  @override
  void initState() async {
    sharedPreferences = await SharedPreferences.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: _getWidget(),
    );
  }

  _getWidget() {
    if (sharedPreferences != null) {
      String? token = sharedPreferences!.getString("token");
      if (token != null) {
        return Dashboard();
      }
      return homepage();
    }
    return SplashScreen();
  }
}
