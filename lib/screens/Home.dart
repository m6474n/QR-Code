import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/AuthController.dart';
import 'package:qr_code/controller/HomeController.dart';
import 'package:qr_code/screens/admin/ScanQRCode.dart';

class Home extends StatelessWidget {
   Home({super.key});
final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          return PopScope(
            onPopInvoked: (_){
          SystemNavigator.pop();
            },
            child: Scaffold(

              appBar: AppBar(
               automaticallyImplyLeading: false,
                title: Text('Home'),
                actions: [IconButton(onPressed: (){
                  authController.logout();
                }, icon: Icon(Icons.logout)),]            ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 14.0),
                //   child: Text("Reminders",style: TextStyle(color: Colors.deepPurple, fontSize: 22, fontWeight: FontWeight.bold),),
                // ),
                // Container(height: 150,child: controller.showReminder(),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text("Avaliable Devices",style: TextStyle(color: Colors.deepPurple, fontSize: 22, fontWeight: FontWeight.bold),),
              ),
                Container(
                height: 200,
                child:   controller.getDevices(),)
              ],),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  controller.nameController.clear();
                  controller.popUp(context);
                },
                child: Icon(Icons.add),
              ),
            ),
          );
        });
  }
}
