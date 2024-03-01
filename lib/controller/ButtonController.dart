import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/services/NotificationServices.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:http/http.dart' as http;

class ButtonController extends GetxController {
  final user = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance.collection("users");
  final remindersRef = FirebaseFirestore.instance.collection("Reminders");
  List ringerList = [];
  String?  userName;
  Stream? userStream;
  RxString selectedTime = "0".obs;
getUserData()async{
  await userRef.doc(user!.uid).get().then((value){
    userName = value['name'];
  });
  update();
}
  Future<List<String>> getAssignedDeviceIds() async {
    List<String> ids = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("Assigned Devices")
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          ids.add(doc.id);
        }
      }
    } catch (e) {
      print("Error getting assigned device IDs: $e");
    }

    return ids;
  }

  getUser() {
    if (ringerList.isNotEmpty) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where(FieldPath.documentId, whereIn: ringerList)
              .snapshots(),
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
                child: Text("No Device Available"),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3.0, vertical: 2),
                      child: Card(
                          child: ListTile(
                        leading: CircleAvatar(
                            radius: 8,
                            backgroundColor:
                                snapshot.data?.docs[index]['availability'] ? Colors.green : Colors.grey,
                          ),
                            onLongPress: (){
                            bottomSheet(user!.uid, snapshot.data!.docs[index]['deviceToken'], snapshot.data!.docs[index]['id'], snapshot.data!.docs[index]['name']);
                            },
                        onTap: () {
                          snapshot.data?.docs[index]['availability'] ? sendNotification(snapshot.data?.docs[index]['deviceToken']):bottomSheet(user!.uid, snapshot.data!.docs[index]['deviceToken'], snapshot.data!.docs[index]['id'], snapshot.data!.docs[index]['name']);

                        },
                        title: Text(snapshot.data!.docs[index]['name']),
                            trailing: Text( snapshot.data?.docs[index]['availability'] ? "Online":"Offline"),
                      )),
                    );
                  });
            }
          });
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }


  NotificationService service = NotificationService();

  ///send notificaion
  sendNotification(String token) async {
    print("Notification Sent");
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

  }
  bottomSheet(String id, String token, String ringerId, String ringerName) {
    Get.bottomSheet(BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 60,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      addReminderDetails(context, ringerId, ringerName);
            },
                    leading: Icon(Icons.person),
                    title: Text("Add reminder"),
                  ),


                ],
              ),
            ),
          );
        }));
  }
final reminderController = TextEditingController();

  addReminderDetails(BuildContext context, String ringerId, String ringerName) {
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
                    onTap: () {
                      addReminder(ringerId, selectedTime.value, userName!, reminderController.text, ringerName);

                    },
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

  dateTimePicker(BuildContext context) async {
    return DatePicker.showTimePicker(context,
        showTitleActions: true,
        locale: LocaleType.en,
        showSecondsColumn: false,
        onChanged: (time) => selectedTime.value =DateFormat("hh:mm a").format(time),
        onConfirm: (time) {
          selectedTime.value = DateFormat("hh:mm a").format(time);
        });
  }

  addReminder(String id, String time, String user, String description, String ringerName){
    EasyLoading.show(status: "Adding...");
    remindersRef.add({
      "id": id,
      "name": ringerName,
      "from": user,
      "reminder": description,
      "time": time
    }).then((value){
      EasyLoading.showSuccess("Reminder Added!");
      reminderController.clear();
      Get.back();
    }).onError((error, stackTrace){
      EasyLoading.showError(error.toString());
    });

  }

  @override
  void onInit() {
    // TODO: implement onInit
    getAssignedDeviceIds().then((value) {
      ringerList = value;
      update();
      print(ringerList);
    });
getUserData();
    super.onInit();
  }
}
