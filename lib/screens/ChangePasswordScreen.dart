import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qr_code/components/CustomButton.dart';
import 'package:qr_code/components/PasswordField.dart';
import 'package:qr_code/controller/AuthController.dart';
import 'package:qr_code/controller/adminController.dart';

class ChangePassword extends StatefulWidget {
  String userId;
   ChangePassword({super.key, required this.userId});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdminController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Change Password"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    PasswordField(
                        lable: "Enter New Password",
                        obscure: true,
                        controller: controller.passController,
                        prefixIcon: Icons.password,
                        validator: (value) {
                          return value.isEmpty ? "Enter Valid password" : null;
                        }),
                    PasswordField(
                        lable: "Confirm Password",
                        obscure: true,
                        controller: controller.confirmPass,
                        prefixIcon: Icons.password,
                        validator: (value) {
                          return value.isEmpty? "Enter Valid password": null;
                        })
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomButton(
                label: 'Change Password',
                onTap: () {
                  if(controller.formKey.currentState!.validate()){
                    if(controller.passController.text == controller.confirmPass.text){
                      controller.changePass(widget.userId);
                    }else{
                      EasyLoading.showToast("Password not matched!");
                    }

                  }

                },
                isLoading: false,
              ),
            ),
          );
        });
  }
}
