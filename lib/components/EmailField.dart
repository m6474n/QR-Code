import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailField extends StatelessWidget {
  final String lable;

  final TextEditingController controller;
  final IconData prefixIcon;
  final FormFieldValidator validator;

  EmailField(
      {super.key,
        required this.lable,

        required this.controller,
        required this.prefixIcon, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
validator: validator,
        decoration: InputDecoration(
            hintText: lable,
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.deepPurple,
            ),

            filled: true,
            fillColor: Colors.black87,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
