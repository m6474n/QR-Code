import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/AuthController.dart';

import '../../controller/adminController.dart';
class AssignDevice extends StatefulWidget {
  final String id;
  const AssignDevice({super.key, required this.id});

  @override
  State<AssignDevice> createState() => _AssignDeviceState();
}

class _AssignDeviceState extends State<AssignDevice> {
  final controller = Get.find<AdminController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("All Ringers"),),body: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Container(
              alignment: Alignment.centerLeft,
              child: Text("Assigned Devices", style: TextStyle(color: Colors.deepPurple, fontSize: 18),textAlign: TextAlign.left,)),
          SizedBox(height: 8,),
          Flexible(child: controller.getAssignedDevices(widget.id),),
        SizedBox(height: 8,),
          Container(
              alignment: Alignment.centerLeft,
              child: Text("Unassigned Devices",style: TextStyle(color: Colors.deepPurple, fontSize: 18),)),
          SizedBox(height: 8,),
        Flexible(child: controller.getUnAssignedDevices(widget.id),),
          SizedBox(height: 8,),
        ],
      ),
    ),);
  }
}
