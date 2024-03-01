import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final VoidCallback ontap;
  final TextInputType keyBoardType;
final FormFieldValidator validator;

  const CustomInput(
      {super.key,
      required this.controller,
      required this.label,
      required this.prefixIcon,
      required this.ontap,  this.keyBoardType = TextInputType.text,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
validator:  validator,
      onTap: ontap,
      controller: controller,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.deepPurple,
          ),
          filled: true,
fillColor: Colors.black87,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none)),
    );
  }
}
