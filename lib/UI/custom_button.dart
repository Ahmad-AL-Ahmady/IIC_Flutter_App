// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final Function? navigation;
  const CustomButton({required this.name, required this.navigation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          onPressed: () {
            navigation;
          },
          style: ElevatedButton.styleFrom(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            primary: const Color(0xff3c6970),
            padding: const EdgeInsets.all(30),
          ),
          child: Text(
            name,
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
