import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:qr_code/Testing/TestHome.dart';
import 'package:qr_code/screens/button/ButtonScreen.dart';
import 'package:qr_code/screens/Home.dart';
import 'package:qr_code/screens/auth/LoginScreen.dart';
import 'package:qr_code/screens/ringer/RingerScreen.dart';
import 'package:qr_code/services/auth_services.dart';

import '../screens/admin/AdminScreen.dart';

class SplashService {
  final userRef = FirebaseFirestore.instance.collection("users");
  void isLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
        Timer(const Duration(seconds: 3), () async {
          Get.to(() => const AdminScreen());
        });
    } else {
    Timer(const Duration(seconds:4),()async{
      Get.to(() => const LoginScreen());
    });
    }
  }
}
