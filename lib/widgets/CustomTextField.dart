import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.controller,
      this.keyboardType,
      this.onChanged,
      this.hintText,
      this.icon,
      this.obscureText = false,
      this.suffixIcon});

  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldSetter onChanged;
  final String hintText;
  final Icon icon;
  final bool obscureText;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.grey[300],
          filled: true,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
