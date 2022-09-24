import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Function? validation;
  final Icon? prefixIcon;
  final String hint;
  final TextInputType type;
  final TextEditingController? controler;
  // ignore: use_key_in_widget_constructors
  const CustomTextField(
      {required this.label,
      this.controler,
      this.hint = "User name",
      this.validation,
      required this.type,
      this.prefixIcon});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 62,
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
            controller: controler,
            validator: (value) => validation!(value),
            keyboardType: type,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14, bottom: 14),
                prefixIcon: prefixIcon,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        ),
      ],
    );
  }
}
