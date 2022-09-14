import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class DropDownList extends StatefulWidget {
  const DropDownList({Key? key}) : super(key: key);

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  final items = ["Item 1", "Item 2", "Item 3", "Item 4"];
  String? value;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Container(
            width: 300,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 14,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                )),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                iconSize: 36,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                style: TextStyle(color: Colors.white),
                isExpanded: true,
                items: items.map(buildMenuItem).toList(),
                onChanged: (value) => setState(() => this.value = value),
              ),
            ),
          ),
        ),
      );

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
