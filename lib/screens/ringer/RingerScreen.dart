import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/AuthController.dart';
import 'package:qr_code/controller/RingerController.dart';
import 'package:qr_code/screens/auth/LoginScreen.dart';

import '../../services/auth_services.dart';
//
// class RingerScreen extends StatefulWidget {
//   const RingerScreen({super.key});
//
//   @override
//   State<RingerScreen> createState() => _RingerScreenState();
// }
//
// class _RingerScreenState extends State<RingerScreen> {
//   // final authController = Get.put(AuthController());
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//         init: RingerController(),
//         builder: (controller) {
//           return Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               // title: Text(controller.userName),
//               actions: [
//                 IconButton(
//                     onPressed: () {
//     AuthManager().logout().then((value) {
//     EasyLoading.showToast("Logout!");
//     Get.to(LoginScreen());});
//
//
//                     },
//                     icon: Icon(Icons.logout))
//               ],
//             ),
//             body: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 18),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 50,
//                     // child: controller.updateAvailability(),
//                   ),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Reminders",
//                           style: TextStyle(
//                               color: Colors.deepPurple,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         // Container(
//                         //   decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//                         //   child: Column(
//                         //     children: [
//                         //       Table(
//                         //         children: [
//                         //           TableRow(children: [
//                         //             TableCell(
//                         //                 child: Container(
//                         //                     height: 50,
//                         //                     child: Center(child: Text("User")))),
//                         //             TableCell(
//                         //                 child: Container(
//                         //                     height: 50,
//                         //                     child: Center(child: Text("Reminder")))),
//                         //             TableCell(
//                         //                 child: Container(
//                         //                     height: 50,
//                         //                     child: Center(child: Text("Time")))),
//                         //           ])
//                         //         ],
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),
//                     // controller.getReminders()
//
//                     ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 // controller.generateQR(context);
//               },
//               child: Icon(Icons.add),
//             ),
//           );
//         });
//   }
// }
import 'package:flutter/material.dart';
class RingerScreen extends StatefulWidget {
  const RingerScreen({super.key});

  @override
  State<RingerScreen> createState() => _RingerScreenState();
}

class _RingerScreenState extends State<RingerScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: RingerController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(controller.userName),
              actions: [
                IconButton(
                    onPressed: () {
                      AuthManager().logout().then((value) {
                        EasyLoading.showToast("Logout!");
                        Get.to(LoginScreen());
                      });
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: controller.updateAvailability(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reminders",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                          child: Column(
                            children: [
                              Table(
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                        child: Container(
                                            height: 50,
                                            child: Center(child: Text("User")))),
                                    TableCell(
                                        child: Container(
                                            height: 50,
                                            child: Center(child: Text("Reminder")))),
                                    TableCell(
                                        child: Container(
                                            height: 50,
                                            child: Center(child: Text("Time")))),
                                  ])
                                ],
                              ),
                            ],
                          ),
                        ),
                        controller.getReminders()

                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // controller.generateQR(context);
              },
              child: Icon(Icons.add),
            ),
          );
        });
  }


}