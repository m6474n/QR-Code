import 'dart:async';
import 'dart:convert';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:qr_code/screens/admin/ScanQRCode.dart';
import 'package:qr_code/services/NotificationServices.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  NotificationService service = NotificationService();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final userName = FirebaseAuth.instance.currentUser!.displayName;
  final nameController = TextEditingController();
  final dbRef = FirebaseFirestore.instance.collection("DeviceTokens");
  final user = FirebaseAuth.instance.currentUser;
  final networkInfo = NetworkInfo();
  final reminderController = TextEditingController();

  String? myToken, myWifi;
  final DeviceStream = FirebaseFirestore.instance
      .collection("DeviceTokens")
      .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .snapshots();
//get all devices that you added
  getDevices() {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.deepPurpleAccent,
          ));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('something_went_wrong'));
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Device Avaiable"));
        } else {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        nameController.text =
                            snapshot.data!.docs[index]['name'];
                        showBottomSheet(
                            snapshot.data!.docs[index].id,
                            snapshot.data!.docs[index]['token'],
                            snapshot.data!.docs[index]['userId']);
                      },
                      title: Text(snapshot.data!.docs[index]['name']),
                      trailing: GestureDetector(
                          onTap: () {
                            sendNotification(
                                snapshot.data!.docs[index]['token']);
                          },
                          child: Icon(Icons.notifications_active)),
                    ),
                  ),
                );
              });
        }
      },
      stream: DeviceStream,
    );
  }

//Generated QR code
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
  String? otherDeviceUid;

  //Decode data from QR Code
  decodeQR(String data) {
    var res = jsonDecode(data);
    otherDeviceToken = res['token'];
    otherDeviceWifi = res["wifi"];
    otherDeviceUid = res['userId'];
  }

//Bottom Sheet
  showBottomSheet(String id, String token, String otherUserID) {
    Get.bottomSheet(BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 180,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      showPopUp(context, id);
                    },
                    leading: Icon(Icons.person),
                    title: Text("Edit Name"),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     // showPopUp(context, id);
                  //
                  //     dateTimePicker(context,token);
                  //     // print(scheduleTime);
                  //   },
                  //   leading: Icon(Icons.notification_add),
                  //   title: Text("Set Reminder"),
                  // ),
                  ListTile(
                    onTap: () {
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

  TimeOfDay initialTime = TimeOfDay.now();
  RxString selectedTime = "0".obs;
  Duration remainingTime = Duration();

  // Set Reminder
  int duration = 0;
  dateTimePicker(BuildContext context) async {
    return DatePicker.showTimePicker(context,
        showTitleActions: true,
        locale: LocaleType.en,
        showSecondsColumn: false,
        onChanged: (time) => selectedTime.value ="${time.hour}:${time.minute}",
        onConfirm: (time) {
          selectedTime.value = "${time.hour}:${time.minute}";
          update();
          // print(scheduleTime);
        });
    // DateTime? pickedTime = await DatePicker.showTimePicker(
    //   context,
    //   currentTime: selectedTime,
    //   showSecondsColumn: false,
    //
    //   locale: LocaleType.en,
    // );
    //
    // if (pickedTime != null && pickedTime != selectedTime) {
    //     selectedTime = pickedTime;
    //     scheduleTask();
    //     update();
    // }
  }

//////////////
  getCurrentTime() async {
    DateTime currentTime = DateTime.now();
    return currentTime;
  }

/////////////////////

  /// Set Reminder
  ///
  ///
  setReminder(String description, DateTime time) {
    print("Reminder Set!  ");
  }

  addReminderDetails(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Add Reminder"),
            content: TextFormField(
              controller: reminderController,
              decoration: InputDecoration(
                  hintText: "Description",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none)),
            ),
            actions: [
              GestureDetector(
                  onTap: () {
                    dateTimePicker(context);
                    update();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: selectedTime.value == "0"? Text("Pick Time"): Obx(() => Text(selectedTime.value))),
                  )),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: 100,
                      child: Center(child: Text("Add")),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      update();
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      child: Center(child: Text("Cancel")),
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

//Show Reminder
  showReminder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Reminders")
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Reminder available'),
            );
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var res =
                    snapshot.data!.docs[index]['time'].toString().split(" ");
                var time = "${res[0]}:${res[1]}";
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 16, height: 2),
                          ),
                          Text(
                            'Reminder!',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 32,
                                height: 0.5,
                                letterSpacing: 1.8,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'for ${time}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                letterSpacing: 3,
                                height: 2.5),
                          ),
                          Text(
                            'from ${snapshot.data!.docs[index]['from']}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                height: 0.4,
                                letterSpacing: 2.3,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                );
              });
        });
  }

// Show Pop to change device name
  showPopUp(BuildContext context, String id) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Edit Name"),
            content: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: "Device name",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none)),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        updateName(id);
                      },
                      child: Container(
                        height: 45,
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

//Update device name from firebase
  updateName(String id) {
    dbRef.doc(id).update({"name": nameController.text}).then((value) {
      EasyLoading.showSuccess("Name Updated!");
      Get.back();
      Get.back();
      nameController.clear();
    });
  }

// Remove device from firebase
  removeDevice(String id) {
    dbRef.doc(id).delete().then((value) {
      EasyLoading.showSuccess("Device Removed!");
      Get.back();
    });
    update();
  }

// Show Pop for Add New Device
  popUp(BuildContext context) {
    update();
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: 170,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
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
                  ),
                  ListTile(
                    onTap: () {
                      Get.back();
                      addReminderDetails(context);
                      print("Set reminder!");
                    },
                    leading: Icon(Icons.notification_add),
                    title: Text('Add Reminder'),
                  )
                ],
              ),
            ),
          );
        });
  }

// add device to firebase
  storeDataToFirebase() {
    dbRef.add({
      "id": uid.toString(),
      "userId": otherDeviceUid,
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

// Get wifi Address
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

// Generate data for QR Code
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

  bool isDeviceFound = false;

  ///send notificaion
  sendNotification(String token) async {
    service.getDeviceToken().then((value) async {
      var data = {
        'to': token,
        'priority': 'high',
        'notification': {
          'title': "New Notification!",
          'body': "from: ${userName}",
        }
      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAubZCUDQ:APA91bF-91J8-5pvykjOao6nAC-MeBLSMDV5BwCNMePMGsTVG-D3BQaZvabBVVzIpJc-NrFjvtEhfE8BG3V_bGzKcW5ZYTZTAkb_Y8OHDRQte9LcV6rkS1l_0sEJyk7gOGsSNoj77MMt'
          });
    });
  }

  /////////////////////////////

  @override
  void onInit() {
    // TODO: implement onInit

    generateData();
    service.firebaseInit();
    service.requestNotification();
    super.onInit();
  }
}
