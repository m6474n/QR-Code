import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/HomeController.dart';
import 'package:qr_code/screens/ScanQRCode.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(

            appBar: AppBar(
             automaticallyImplyLeading: false,
              title: Text('Home'),
            ),
            body: controller.getDevices(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                controller.nameController.clear();
                controller.popUp(context);
              },
              child: Icon(Icons.add),
            ),
          );
        });
  }
}
