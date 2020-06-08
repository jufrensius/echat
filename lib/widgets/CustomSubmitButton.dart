import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomSubmitButton extends StatelessWidget {
  CustomSubmitButton({this.label, this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50.0,
      child: RaisedButton(
        color: Color.fromRGBO(112, 189, 165, 1),
        disabledColor: Color.fromRGBO(74, 210, 149, 0.5),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto Bold',
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
