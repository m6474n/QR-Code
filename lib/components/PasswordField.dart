import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/AuthController.dart';

class PasswordField extends StatelessWidget {
  final String lable;
  bool obscure;
  final TextEditingController controller;
  final IconData prefixIcon;
  final FormFieldValidator validator;

  PasswordField(
      {super.key,
      required this.lable,
      required this.obscure,
      required this.controller,
      required this.prefixIcon, required this.validator});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthController(),
        builder: (_controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              validator: validator,
              controller: controller,
              obscureText: _controller.toggle,
              decoration: InputDecoration(
                  hintText: lable,
                  prefixIcon: Icon(
                    prefixIcon,
                    color: Colors.deepPurple,
                  ),
                  suffixIcon: obscure == true
                      ? GestureDetector(
                          onTap: () {
                            _controller.obscureToggle();
                          },
                          child: Icon(_controller.toggle == true
                              ? Icons.visibility_off
                              : Icons.visibility))
                      : null,
                  filled: true,
fillColor: Colors.black87,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none)),
            ),
          );
        });
  }
}
