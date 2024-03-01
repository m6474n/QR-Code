import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/adminController.dart';
import 'package:qr_code/screens/admin/RegisterScreen.dart';
import 'package:qr_code/screens/admin/remindesScreen.dart';
import 'package:qr_code/screens/admin/manage_buttons.dart';
import 'package:qr_code/screens/admin/manage_ringers.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdminController(),
        builder: (controller){
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Admin Dashboard'),
          actions: [IconButton(onPressed: (){
controller.logout();

          }, icon: Icon(Icons.logout))],
        ),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
          ),
          children: [
            GridItem(title: "Add Device", onTap: (){

              Get.to(()=>RegisterScreen());
            }, icon: Icons.devices_rounded),
            GridItem(title: "Manage Buttons", onTap: (){
              Get.to(()=>ManageButtons());

            }, icon: Icons.send_to_mobile ),
            GridItem(title: "Manage Ringers", onTap: (){
              Get.to(()=>ManageRingers());


            }, icon: Icons.install_mobile ),
            // GridItem(title: "Reminders", onTap: (){Get.to(()=> RemindersScreen());}, icon: Icons.device_hub ),
            // GridItem(title: "Change Password", onTap: (){}, icon: Icons.key )


          ],
          // Number of items in the grid

          // Replace this with the widget you want to display in each grid item
        ),
      );
    });
  }
}

class GridItem extends StatelessWidget {
  String title;
  VoidCallback onTap;
  IconData icon;
  GridItem({required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 42,),
            Text(title)],),),
    );
  }
}
