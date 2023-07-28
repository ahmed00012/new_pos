import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)?validator;
  final Function(String?)?onChange;
  final bool numerical;
  final int? maxLines;
  final Widget? suffixIcon;


  CustomTextField(
      {Key? key, required this.controller, required this.label, this.hint,this.validator,
      this.numerical = false , this.maxLines = 1,this.onChange , this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: numerical?TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        focusedBorder:const OutlineInputBorder(
          borderSide:  BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedErrorBorder:  const OutlineInputBorder(
          borderSide:  BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:  BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: size.height * 0.02,
            color: Colors.black45,
          ),
        ),
        border: InputBorder.none,
        suffixIcon: suffixIcon
      ),

      validator: validator,
      onChanged: onChange,
    );
  }
}
