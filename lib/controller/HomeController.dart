import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:qr_code/controller/AuthController.dart';
import 'package:qr_code/screens/Home.dart';
import 'package:qr_code/screens/ScanQRCode.dart';
import 'package:qr_code/services/NotificationServices.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class HomeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  NotificationService service = NotificationService();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final nameController = TextEditingController();
  final dbRef =  FirebaseFirestore.instance.collection("DeviceTokens");
  final networkInfo = NetworkInfo();
  String? myToken, myWifi;
  final DeviceStream = FirebaseFirestore.instance
      .collection("DeviceTokens")
      .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .snapshots();

  getDevices() {

    return StreamBuilder(
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent,));
        }
        else if (!snapshot.hasData) {
          return const Center(child: Text('something_went_wrong'));
        }
      else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
                "No Device Avaiable"
              ));
        }
      else{
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      nameController.text =snapshot.data!.docs[index]['name'];
                      showBottomSheet(snapshot.data!.docs[index].id);
                    },
                    title: Text(snapshot.data!.docs[index]['name']),
                  ),
                ),
              );
            });}
      },
      stream: DeviceStream,
    );

  }

  String? jsonData;
  generateQR(BuildContext context) {
    generateData().then((value) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                "My QR",
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w900),
              )),
              surfaceTintColor: Colors.white,
              content: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Center(
                  child: QrImageView(
                    data: jsonData!,
                    size: 200,
                    version: QrVersions.auto,
                  ),
                ),
              ),
            );
          });
    });
  }

  String? otherDeviceWifi;
  String? otherDeviceToken;
  decodeQR(String data) {
    var res = jsonDecode(data);
    otherDeviceToken = res['token'];
    otherDeviceWifi = res["wifi"];
  }
showBottomSheet(String id){
    Get.bottomSheet(BottomSheet(onClosing: (){}, builder: (context){
      return  Container(padding: EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          height: 130,
          child: Column(
            children: [
              ListTile(
                onTap: (){
                  showPopUp(context, id);
                },
                leading: Icon(Icons.person),
                title: Text("Edit Name"),
              ),
              ListTile(
                onTap: (){
                  removeDevice(id);
                },
                leading: Icon(Icons.delete),
                title: Text("Remove Device"),
              )
            ],
          ),
        ),
      );
    }));
}

showPopUp(BuildContext context, String id){
    return showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: Text("Edit Name"),
        content: TextFormField(controller: nameController,
          decoration: InputDecoration(
              hintText: "Device name",
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none)),
        ),

       actions: [ GestureDetector(
         onTap: (){
         updateName(id);
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
       ),],

      );
    });
}
updateName(String id){
    dbRef.doc(id).update({
      "name": nameController.text
    }).then((value){
      EasyLoading.showSuccess("Name Updated!");
      Get.back();
      Get.back();
      nameController.clear();
    });



}
  removeDevice(String id){
   dbRef.doc(id).delete().then((value){
     EasyLoading.showSuccess("Device Removed!");
     Get.back();

   });
    update();
  }

  popUp(BuildContext context) {
    update();
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      // scanQr().then((value){
                      //  decodeQR(value);
                      //  Get.to(ScanQR(token: value['token'],wifi: value['wifi'],));
                      //
                      // });
                      Get.back();
                      Get.to(QRCodeScannerScreen());
                    },
                    leading: Icon(Icons.document_scanner_outlined),
                    title: Text('Scan New Device'),
                  ),
                  ListTile(
                    onTap: () {
                      Get.back();
                      generateQR(context);
                    },
                    leading: Icon(Icons.qr_code),
                    title: Text('Generate QR '),
                  )
                ],
              ),
            ),
          );
        });
  }

  storeDataToFirebase() {
    dbRef.add({
      "id": uid.toString(),
      "wifi": otherDeviceWifi,
      "token": otherDeviceToken,
      "name": nameController.text
    }).then((value) {
      EasyLoading.showSuccess("Device Saved Successfully");
      nameController.clear();
      Get.back();
      Get.back();
    });
    update();
  }

  getWifiInfo() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.wifi) {
      String? wifiBSSID = await networkInfo.getWifiBSSID();
      // You may want to send this information to another device and compare.
      print(wifiBSSID);

      return wifiBSSID; // Replace with the actual BSSID
    }

    return false; // Not connected to Wi-Fi
  }

  generateData() async {
    service.getDeviceToken().then((value) {
      myToken = value;
    });

    getWifiInfo().then((value) {
      myWifi = value;
    });

    Map<String, dynamic> userData = {
      "wifi": myWifi.toString(),
      "token": myToken,
      // "email": "john.doe@example.com",
    };
    // Convert data to JSON
    jsonData = jsonEncode(userData);

    update();
  }

//QrScanning
  bool isDeviceFound = false;

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    generateData();
    super.onInit();
  }
}
