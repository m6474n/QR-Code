import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/AuthController.dart';
import 'package:qr_code/screens/auth/LoginScreen.dart';
import 'package:qr_code/services/auth_services.dart';

import '../../controller/ButtonController.dart';

class ButtonScreen extends StatefulWidget {
  const ButtonScreen({super.key});

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {

    return GetBuilder(
        init: ButtonController(),
        builder: (controller){
        return Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Available Device'),
          actions: [IconButton(onPressed: (){
            AuthManager().logout().then((value) {
              EasyLoading.showToast("Logout!");
              Get.to(LoginScreen());
            });
          }, icon: Icon(Icons.logout))],),
          body:controller.getUser()
        );
    });
  }
}
