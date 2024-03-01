import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:qr_code/controller/HomeController.dart';
import 'package:qr_code/services/NotificationServices.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sliding_switch/sliding_switch.dart';

class RingerController extends GetxController {
  NotificationService service = NotificationService();
  final networkInfo = NetworkInfo();
  final auth = FirebaseAuth.instance.currentUser!;
  final userRef = FirebaseFirestore.instance.collection("users");
  String? myToken, myWifi;
  String? jsonData;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool btnValue = false;
  final remindersRef = FirebaseFirestore.instance.collection("Reminders");

  String userName = "Loading...";

  getData() async {
    await userRef.doc(auth.uid).get().then((value) {
      btnValue = value["availability"];
      userName = value["name"];
      update();
    });
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
      "userId": uid
      // "email": "john.doe@example.com",
    };
    // Convert data to JSON
    jsonData = jsonEncode(userData);

    update();
  }

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

  updateRingerProfile() {
    service.getDeviceToken().then((value) {
      myToken = value;
    });
    getWifiInfo().then((value) {
      myWifi = value;
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
          ""
              'deviceToken': myToken,
          'wifi_info': myWifi
        })
        .then((value) {})
        .onError((error, stackTrace) {
          EasyLoading.showError(error.toString());
          update();
        });
  }

  getReminders() {
    print(auth.uid);
    return Flexible(
      child: StreamBuilder(
        stream: remindersRef.where('id', isEqualTo: auth.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Reminders Available"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            height: 40,
                            child: Center(child: Text(snapshot.data!.docs[index]['from'])),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            height: 40,
                            child: Center(child: Text(snapshot.data!.docs[index]['reminder'])),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            height: 40,
                            child: Center(child: Text(snapshot.data!.docs[index]['time'])),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  updateAvailability() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          btnValue ? "Online" : "Offline",
          style: TextStyle(fontSize: 18),
        ),
        Switch(
            value: btnValue,
            onChanged: (bool newVal) {
              btnValue = newVal;
              userRef.doc(auth.uid).update({"availability": btnValue});
              update();
            }),
      ],
    );
    // return SlidingSwitch(value: btnValue, onChanged: (bool newValue){
    //   btnValue = newValue;
    //
    //   update();
    // }, onTap: (){}, onDoubleTap: (){}, onSwipe: (){});
  }

  bool BtnValue = false;
  getSwitch() {}

  @override
  void onInit() {
    generateData();
    service.getDeviceToken().then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "deviceToken": value,
      });
      print(value);
    });
    getWifiInfo().then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"wifi_info": value});
      print(value);
    });
    getData();
    service.firebaseInit();

    // updateRingerProfile();
    // TODO: implement onInit
    super.onInit();
  }
}
