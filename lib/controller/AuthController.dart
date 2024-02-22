import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/screens/Home.dart';
import 'package:qr_code/screens/LoginScreen.dart';
import 'package:qr_code/services/NotificationServices.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class AuthController extends GetxController {

  UserCredential? user;

  // final Stream profile  = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();


  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore dbRef = FirebaseFirestore.instance;


  logout() {
    EasyLoading.show(status: "Logging out, Please wait...",);
    auth.signOut().then((value) {
      EasyLoading.dismiss();
      Get.snackbar('Logout Successfully', '',
          backgroundColor: Colors.grey, colorText: Colors.white);
      Get.off(LoginScreen());
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
  }

  Future getGoogleCredentials() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return credentials;
  }


  signinWithGoolge() {
    EasyLoading.show(status: "Signing in with Google, Please wait...",);

    OAuthCredential credential;
    getGoogleCredentials().then((value) async {
      credential = value;
      await auth.signInWithCredential(credential).then((value) {
        user = value;
        Get.snackbar('Login with Google', "Successfully!",
            backgroundColor: Colors.orange, colorText: Colors.white);
        addUserToFirebase(
            user!.user!.uid, user!.user!.displayName!, user!.user!.email!,
            user!.user!.photoURL!);
        EasyLoading.dismiss();
        Get.to(Home());
      }).onError((error, stackTrace) {
        Get.snackbar(
            'Failed to login', error.toString(), backgroundColor: Colors.red,
            colorText: Colors.white);
        EasyLoading.dismiss();
      });
    });
  }


  /// Firebase Database

  addUserToFirebase(String id, String name, String email, String profile,) {
    dbRef.collection("QRUsers").doc(id).set({
      'id': id,
      'name': name,
      'email': email,
      'profile': profile
    });
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    // Request location permission
    PermissionStatus status = await Permission.location.request();

    // Handle permission status

  }
}
