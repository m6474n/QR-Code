import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/adminController.dart';

class ManageRingers extends StatefulWidget {
  const ManageRingers({super.key});

  @override
  State<ManageRingers> createState() => _ManageRingersState();
}

class _ManageRingersState extends State<ManageRingers> {
  final adminController = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Ringers"),
      ),
      body: adminController.getAllRingers()
    );
  }
}
