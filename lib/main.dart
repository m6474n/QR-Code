import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/screens/AddDevice.dart';
import 'package:qr_code/screens/Home.dart';
import 'package:qr_code/screens/LoginScreen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code',
      theme: ThemeData.dark(),
      builder: EasyLoading.init(),
      home:LoginScreen()
    );
  }




  void _handlePermissionStatus(BuildContext context, PermissionStatus status) {
    if (status == PermissionStatus.granted) {
      // Permission granted, proceed with location-related tasks
      print('Location permission granted');
    } else if (status == PermissionStatus.denied) {
      // Permission denied
      print('Location permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Permission denied and permanently denied by the user
      // Open app settings to allow the user to enable the permission manually
      openAppSettings();
    } else if (status == PermissionStatus.restricted) {
      // Permission restricted, usually due to parental controls
    }
  }
}