
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/adminController.dart';
import 'package:sliding_switch/sliding_switch.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool btnValue = false;

  @override
  Widget build(BuildContext context) {
   return GetBuilder(
       init: AdminController(),
       builder: (controller){
         return Scaffold(body: StreamBuilder(stream: FirebaseFirestore.instance.collection("users").doc("Itw2924cXGOr3fUXtYRAsaxDblu2").collection("Assigned Devices").snapshots(),builder: (context,snapshot){
           return ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (context, index){
             return ListTile(title: Text(snapshot.data!.docs[index]['status'].toString()),);

           });
         },),);
       });
  }
}
// schedule task
