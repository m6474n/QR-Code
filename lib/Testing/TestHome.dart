import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/Testing/testController.dart';
import 'package:qr_code/controller/userProfileController.dart';
import 'package:qr_code/main.dart';
import 'package:qr_code/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestHome extends StatefulWidget {
  const TestHome({super.key});

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  final profile = Get.put(UserController());
  final auth = AuthManager();
  Widget build(BuildContext context) {

    return GetBuilder(
        init: TestController(),
        builder: (controller){
      return Scaffold(
        drawer:NavigationDrawer(indicatorColor: Colors.deepPurple,children: [],),
        appBar: AppBar(
         actions: [IconButton(onPressed: (){
           controller.Logout();
         }, icon: Icon(Icons.logout))],
          automaticallyImplyLeading: false,
          title: Text("TestHome"),
        ),
        body: Column(children: [
          auth.userEmail != null ? Text(auth.userName!): Center(child: CircularProgressIndicator())
        ],),
      );
    });
  }
}
