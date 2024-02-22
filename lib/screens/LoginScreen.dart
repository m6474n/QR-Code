import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/AuthController.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthController(),
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login to your account',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 32),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: GestureDetector(
                      onTap: (){
                        controller.signinWithGoolge();
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(12)),

                                         child: Center(child: Text("Login with Google ", style: TextStyle(color: Colors.white, fontSize: 18),)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
