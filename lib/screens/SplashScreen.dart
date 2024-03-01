import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code/services/SplashServices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashService = SplashService();

  @override
  void initState() {
    // TODO: implement initState
    splashService.isLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: LottieBuilder.asset("./assets/animated-qr-code.json", height: 120,width: 120,),),);
  }
}
