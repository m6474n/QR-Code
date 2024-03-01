import 'package:flutter/material.dart';

class CustomButton2 extends StatelessWidget {
  final bool isLoading;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const CustomButton2(
      {super.key,
        required this.label,
        required this.onTap,
        required this.isLoading, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(BorderSide.none),
            color: color,
          ),
          child: isLoading == true
              ? Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          )
              : Center(
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
        ),
      ),
    );
  }
}
