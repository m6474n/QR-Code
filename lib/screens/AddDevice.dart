import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/HomeController.dart';
import 'package:qr_code/screens/Home.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
              body: Center(
                  child:
                      controller.myWifi.toString() == controller.otherDeviceWifi.toString() ?
                      Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
key:  controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New Device Found!",
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(controller: controller.nameController,
                    validator: (value){
                   return value == null || value.isEmpty ? "Enter Valid Name": null;
                    },
                    decoration: InputDecoration(
                        hintText: "Device name",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none)),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: (){
                      if(controller.formKey.currentState!.validate()){
                        controller.storeDataToFirebase();

                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                ],
              ),
            ),
          ):
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Device found!", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),),
                        Text("Please try again."),
                        SizedBox(height: 8,),
                        ElevatedButton(onPressed: () {
                          Get.back();
                          Get.back();
                        }, child: Text("Back to Home Screen"))
                      ],
                    ),
                  ),
                  ));
        });
  }
}
