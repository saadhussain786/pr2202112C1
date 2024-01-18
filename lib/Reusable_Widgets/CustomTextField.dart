import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  String lable;
  String hintText;
  TextEditingController controller;
  ReusableTextField({required this.lable,required this.hintText,required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text('$lable'),
          hintText: "$hintText"),
    );
  }
}
