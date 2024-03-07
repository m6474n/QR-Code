import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/Testing/TestHome.dart';
import 'package:qr_code/Testing/testScreen.dart';
import 'package:qr_code/controller/userProfileController.dart';
import 'package:qr_code/screens/auth/LoginScreen.dart';
import 'package:qr_code/screens/button/ButtonScreen.dart';
import 'package:qr_code/screens/ringer/RingerScreen.dart';
import 'package:qr_code/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:qr_code/screens/SplashScreen.dart';

AuthManager auth = AuthManager();
SharedPreferences? preferences;

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await auth.init();
print(auth.isLoggedIn);

  runApp( MyApp(isLogin:  auth.isLoggedIn,userRole: auth.userRole ??  "",));
}

class MyApp extends StatelessWidget {
  bool isLogin ;
  String userRole;
   MyApp({super.key, required this.isLogin,required this.userRole});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Code',
        navigatorKey: navigatorKey,
        theme: ThemeData.dark(),
        builder: EasyLoading.init(),
        home: isLogin == true ? userRole == "Button" ? ButtonScreen(): RingerScreen(): SplashScreen()
    );
  }
}


