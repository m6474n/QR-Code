import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qr_code/screens/button/ButtonScreen.dart';
import 'package:qr_code/screens/Home.dart';
import 'package:qr_code/screens/auth/LoginScreen.dart';
import 'package:qr_code/screens/ringer/RingerScreen.dart';

import '../screens/admin/AdminScreen.dart';

class SplashService{
final userRef = FirebaseFirestore.instance.collection("users");
  void isLogin()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user!=null){
        await userRef.doc(user.uid).get().then((value) {
          print(value["role"]);
        Timer(Duration(seconds: 3),() async{
          if(value['role'] == "Admin"){

            Get.to(AdminScreen());
          }else if(value['role'] == "Button"){
            Get.to(ButtonScreen());

          }else if(
          value['role'] == "Ringer"
          ){

            Get.to(RingerScreen());

          }
          else{
            Get.snackbar('Something went wrong!', 'Try Again Later',);
            // Get.to(RingerScreen());
          }
        }

        );
      });


    }
    else{
      Timer(Duration(seconds: 3),()=>
          Get.to(LoginScreen())
      );
    }

  }



}