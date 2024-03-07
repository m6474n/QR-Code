import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qr_code/Testing/TestHome.dart';
import 'package:qr_code/Testing/testScreen.dart';
import 'package:qr_code/screens/Home.dart';
import 'package:qr_code/services/auth_services.dart';

class TestController extends GetxController{
  final emailController = TextEditingController();
  final passController = TextEditingController();

  AuthManager auth = AuthManager();

  void login()async{
    EasyLoading.show(status: "Signing in...");
    await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: emailController.text).get().then((value){
      if(value.docs[0]['password'] == passController.text){
        auth.login(value.docs[0]['id'], value.docs[0]['name'], value.docs[0]['email'], value.docs[0]['password'],value.docs[0]['role']);
        EasyLoading.showSuccess("Logged In Successfully");
        Get.to(()=> TestHome());
      }else{
        EasyLoading.showError("Email or password incorrect!");

      }


    });

  }


void Logout(){
    auth.logout().then((value){
      EasyLoading.showToast("logout");
      Get.to(TestScreen());
    });
}

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
}