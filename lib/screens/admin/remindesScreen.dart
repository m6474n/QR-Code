// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_code/controller/adminController.dart';
// class RemindersScreen extends StatefulWidget {
//   const RemindersScreen({super.key});
//
//   @override
//   State<RemindersScreen> createState() => _RemindersScreenState();
// }
//
// class _RemindersScreenState extends State<RemindersScreen> {
//   final controller = Get.find<AdminController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: Text("All Reminders"),),
//     body:  Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//             child: Column(
//               children: [
//                 Table(
//                   children: [
//                     TableRow(children: [
//                       TableCell(
//                           child: Container(
//                               height: 50,
//                               child: Center(child: Text("User")))),
//                       TableCell(
//                           child: Container(
//                               height: 50,
//                               child: Center(child: Text("Reminder")))),
//                       TableCell(
//                           child: Container(
//                               height: 50,
//                               child: Center(child: Text("Time")))),
//                     ])
//                   ],
//                 ),
//               ],
//             ),
//           ),
// controller.getReminders()
//
//         ],
//       ),
//     ),);
//   }
// }
