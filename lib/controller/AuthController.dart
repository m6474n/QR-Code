import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/screens/admin/AdminScreen.dart';
import 'package:qr_code/screens/button/ButtonScreen.dart';
import 'package:qr_code/screens/Home.dart';
import 'package:qr_code/screens/auth/LoginScreen.dart';
import 'package:qr_code/screens/ringer/RingerScreen.dart';
import 'package:qr_code/services/NotificationServices.dart';
import 'package:qr_code/services/auth_services.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class AuthController extends GetxController {

  UserCredential? user;

  // final Stream profile  = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final phoneController = TextEditingController();
  final nameController = TextEditingController();


  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore dbRef = FirebaseFirestore.instance;
  bool _toggle = true;
  bool get toggle => _toggle;
  obscureToggle() {
    _toggle = !_toggle;
    update();
  }
  createUserWithEmail(String email, String password) {

    EasyLoading.show(status: "Creating Profile, Please wait...", );
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
          user = value;
          // user!.user!.updateProfile(displayName:  nameController.text);
          // user!.user.updateDisplayName(displayName) = nameController.text;
      Get.snackbar('User Created Successfully', '',);
      addUserToFirebase(
          user!.user!.uid, nameController.text, user!.user!.email!,
          );
    }).then((value) {

      EasyLoading.dismiss();
      Get.back();
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
  }

  loginWithEmail(String email, String password) async{
    EasyLoading.show(status: "Logging in to your account, Please wait...", );
try{
  await FirebaseFirestore.instance.collection("users").where('email',isEqualTo: emailController.text).get().then((value){
    if(value.docs[0]['role'] == "Admin"){
      auth.signInWithEmailAndPassword(email: email, password: password).then((value)async{
        emailController.clear();
        passController.clear();
        EasyLoading.dismiss();
        Get.snackbar('Login', 'Successfully',);
        Get.to(AdminScreen());
      });
    }else{
      if(value.docs[0]['password'] == passController.text){
        AuthManager().login(value.docs[0]['id'], value.docs[0]['name'], value.docs[0]['email'], value.docs[0]['password'], value.docs[0]['role']).then((value){
          if(AuthManager().userRole == "Button"){
            emailController.clear();
            passController.clear();
            Get.to(ButtonScreen());
            EasyLoading.dismiss();
            Get.snackbar('Login', 'Successfully',);
          }else{
            emailController.clear();
            passController.clear();
            Get.snackbar('Login', 'Successfully',);
            Get.to(RingerScreen());
            EasyLoading.dismiss();
          }
        });
      }else{
        EasyLoading.showToast("Password incorrect!");
      }
    }


  });

}catch(e){
  EasyLoading.showToast(e.toString());
}


    update();
  }
  forgetPassword(){
    EasyLoading.show();
    auth.sendPasswordResetEmail(email: emailController.text).then((value){
      EasyLoading.showSuccess("Password reset link has been sent!,Please Check your email");

    });
  }

  logout() {
    EasyLoading.show(status: "Logging out, Please wait...",);
    auth.signOut().then((value) {
      EasyLoading.dismiss();
      Get.snackbar('Logout Successfully', '',);
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
        Get.snackbar('Login with Google', "Successfully!",);
        addUserToFirebase(
            user!.user!.uid, user!.user!.displayName!, user!.user!.email!,
           );
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



  addUserToFirebase(String id, String name, String email,) {
    dbRef.collection("QRUsers").doc(id).set({
      'id': id,
      'name': name,
      'email': email,

    });
  }

  final otpController = TextEditingController();
  var resendToken;
  signInWithPhone() async{
    EasyLoading.show();
    await auth.verifyPhoneNumber(
        phoneNumber: phoneController.text.toString(),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credentials) {
          EasyLoading.dismiss();
        },
        verificationFailed: (FirebaseAuthException ex) {
          EasyLoading.dismiss();
          Get.snackbar(ex.toString(), "message");
        },
        codeSent: sendCode,
        codeAutoRetrievalTimeout: (e) {
          EasyLoading.dismiss();
          Get.snackbar(e.toString(), "message");
        });
  }
  sendCode(verificationId, token) {
    EasyLoading.showSuccess('OTP has been sent to your phone ${phoneController.text.toString()}');
    resendToken = token;
    // Get.to(Verification(verificationId: verificationId));
    EasyLoading.dismiss();
    update();
  }
String? myToken,myWifi,jsonData;
NetworkInfo networkInfo = NetworkInfo();
  NotificationService  service = NotificationService();
  getWifiInfo() async {
    ConnectivityResult connectivityResult =
    await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.wifi) {
      String? wifiBSSID = await networkInfo.getWifiBSSID();
      // You may want to send this information to another device and compare.
      print(wifiBSSID);

      return wifiBSSID; // Replace with the actual BSSID
    }

    return false; // Not connected to Wi-Fi
  }
  updateRingerProfile(String id){
    service.getDeviceToken().then((value){
      myToken = value;
    });
    getWifiInfo().then((value){
      myWifi = value;
    });
    dbRef.collection("users").doc(id).update({""
        'deviceToken': myToken,'wifi_info': myWifi}).then((value){}).onError((error, stackTrace){
          EasyLoading.showError(error.toString());
          update();
    });

  }
  // generateData() async {
  //   service.getDeviceToken().then((value) {
  //     myToken = value;
  //   });
  //
  //   getWifiInfo().then((value) {
  //     myWifi = value;
  //   });
  //
  //   Map<String, dynamic> userData = {
  //     "wifi": myWifi.toString(),
  //     "token": myToken,
  //     "userId": auth.currentUser!.uid
  //     // "email": "john.doe@example.com",
  //   };
  //   // Convert data to JSON
  //   jsonData = jsonEncode(userData);
  //
  //   update();
  // }





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
