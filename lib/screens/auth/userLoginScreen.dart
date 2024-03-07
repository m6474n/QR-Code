import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qr_code/Testing/testController.dart';
import 'package:qr_code/components/EmailField.dart';
import 'package:qr_code/components/PasswordField.dart';
import 'package:qr_code/controller/AuthController.dart';
import 'package:qr_code/screens/admin/RegisterScreen.dart';
import 'package:qr_code/screens/forgetPass.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: TestController(),
        builder: (controller) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/login.png"), fit: BoxFit.cover)),
                  child: Container(height: 200,color: Colors.black87,),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Test Screen Back',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        EmailField(
                            validator: (value){
                              return value.isEmpty? "Enter valid email": null;
                            },
                            lable: 'Email',
                            controller: controller.emailController,
                            prefixIcon: Icons.email),
                        PasswordField(
                            validator: (value){
                              return value.isEmpty? "Enter valid password": null;
                            },
                            lable: 'Password',
                            obscure: true,
                            controller: controller.passController,
                            prefixIcon: Icons.lock),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(ForgetPassword());
                            },
                            child: Text('Forget Password?'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.login();
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.deepPurple,
                            ),
                            child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                          ),
                          // ),SizedBox(height: 10,),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          // Container(
                          //   child: Center(
                          //       child: Text(
                          //         'Or Sign In with',
                          //         style: TextStyle(color: Colors.grey, fontSize: 16),
                          //       )),
                          // ),
                          // Container(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //
                          //
                          //
                          //       GestureDetector(
                          //           onTap: () {
                          //             controller.signinWithGoolge();
                          //           },
                          //           child: SvgPicture.asset("assets/google.svg",
                          //               height: 50)),
                          //       SizedBox(width: 10,),
                          //       GestureDetector(
                          //           onTap: () {
                          //             Get.to(PhoneLogin());
                          //           },
                          //           child: Icon(Icons.phone, size: 42,color: Colors.deepPurpleAccent,)),
                          //
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          // RichText(
                          //     text: TextSpan(
                          //         style: TextStyle(color: Colors.grey, fontSize: 18),
                          //         text: "Don't have an account.",
                          //         children: [
                          //           TextSpan(
                          //             recognizer: TapGestureRecognizer()
                          //               ..onTap = () {
                          //                 Get.to(RegisterScreen());
                          //               },
                          //             style: TextStyle(
                          //                 color: Colors.deepPurple,
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.bold),
                          //             text: ' Sign up',
                          //           )
                          //         ])),
                        )
                      ],
                    ),
                  ),
                ),
              ],)
          );
        });
  }
}
