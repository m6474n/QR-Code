import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_code/components/CutomInputField.dart';
import 'package:qr_code/components/EmailField.dart';
import 'package:qr_code/components/PasswordField.dart';
import 'package:qr_code/controller/AuthController.dart';
import 'package:qr_code/controller/adminController.dart';
import 'package:qr_code/screens/auth/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GetBuilder(
          init: AdminController(),
          builder: (controller) {
            return Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/register.png"),
                          fit: BoxFit.cover)),
                  child: Container(
                    height: 300,
                    color: Colors.black87,
                  ),
                ),
                Form(
                  key: controller.formKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add Device',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          CustomInput(
                              controller: controller.nameController,
                              label: "Name",
                              prefixIcon: Icons.person,
                              validator: (value){
                                return value.isEmpty ?"Enter valid name": null;
                              },
                              ontap: () {}),
                          SizedBox(
                            height: 8,
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
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                                leading:
                                    Icon(Icons.devices, color: Colors.deepPurple),
                                title: Text('Role'),
                                trailing: DropdownButton<String>(
                                  value: controller.dropdownValue,
                                  items: <String>['Button','Ringer'].map<DropdownMenuItem<String>>((String value){
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value));
                                  }).toList(),
                                  onChanged: (String? newValue){
                                    setState(() {
                                      controller.dropdownValue = newValue!;
                                    });
                                  },
                                ))
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              if(controller.formKey.currentState!.validate()){
                                controller.createUser();
                              }
                              // controller.createUser();
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
                                'Add',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
