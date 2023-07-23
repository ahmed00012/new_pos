import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)?validator;
  final bool numerical;

  CustomTextField(
      {Key? key, required this.controller, required this.label, this.hint,this.validator,
      this.numerical = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      controller: controller,
      keyboardType: numerical?TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        label: Text(
          label,
          style: TextStyle(
            fontSize: size.height * 0.02,
            color: Colors.black45,
          ),
        ),
        border: InputBorder.none,
      ),
      validator: validator,
    );
  }
}
