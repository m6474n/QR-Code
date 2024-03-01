import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/adminController.dart';

class ManageButtons extends StatefulWidget {
  const ManageButtons({super.key});

  @override
  State<ManageButtons> createState() => _ManageButtonsState();
}

class _ManageButtonsState extends State<ManageButtons> {
  final adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Buttons"),
      ),
      body: adminController.getAllButtons()

    );
  }
}
