import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qr_code/screens/admin/remindesScreen.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../screens/auth/LoginScreen.dart';

class AdminController extends GetxController {
  String postName = Random.secure().nextInt(10000).toString();
  String dropdownValue = "Button";
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final remindersRef = FirebaseFirestore.instance.collection("Reminders");
  final userRef = FirebaseFirestore.instance.collection("users");
  final buttonRef = FirebaseFirestore.instance.collection("Buttons");
  final ringerRef = FirebaseFirestore.instance.collection("Ringers");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, dynamic> assignedDevices = {};
  String ringerId = "";

  /// Admin Create new User
  createUser() {
    EasyLoading.show(status: "creating user....");
    auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        .then((value) {
      final user = value;
      if (dropdownValue == "Button") {
        userRef.doc(value.user!.uid.toString()).set({
          "id": user.user!.uid.toString(),
          "name": nameController.text,
          "username": nameController.text + postName,
          "email": emailController.text,
          "password": passController.text,
          "role": dropdownValue
        }).then((value) {
          auth.signOut();
          nameController.clear();
          emailController.clear();
          passController.clear();
          EasyLoading.showSuccess("User Created Successfully!");
          Get.back();
        });
      } else {
        userRef.doc(value.user!.uid.toString()).set({
          "id": user.user!.uid.toString(),
          "name": nameController.text,
          "email": emailController.text,
          "password": passController.text,
          "deviceToken": "",
          "wifi_info": "",
          "availability": true,
          "assigned_to": [],
          "role": dropdownValue
        }).then((value) {
          EasyLoading.showSuccess("User Created Successfully!");
          auth.signOut();
          nameController.clear();
          emailController.clear();
          passController.clear();
          Get.back();
        });
      }
    }).onError((error, stackTrace) {
      Get.snackbar(error.toString(), "", backgroundColor: Colors.redAccent);
    });
  }

// All buttons on ManageButtons Page
  getAllButtons() {
    return StreamBuilder(
        stream: userRef.where("role", isEqualTo: "Button").snapshots(),
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
                        horizontal: 10.0, vertical: 2),
                    child: Card(
                        child: ListTile(
                      onTap: () {
                        nameController.text =
                            snapshot.data!.docs[index]["name"];
                        bottomSheet(snapshot.data!.docs[index]["id"],
                            snapshot.data!.docs[index]["role"]);
                      },
                      title: Text(snapshot.data!.docs[index]['name']),
                      subtitle: Text(snapshot.data!.docs[index]['email']),
                    )),
                  );
                });
          }
        });
  }

// All ringers on ManageRinger page
  getAllRingers() {
    return StreamBuilder(
        stream: userRef.where("role", isEqualTo: "Ringer").snapshots(),
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
                        horizontal: 10.0, vertical: 2),
                    child: Card(
                        child: ListTile(
                      onTap: () {
                        nameController.text =
                            snapshot.data!.docs[index]["name"];
                        bottomSheet(snapshot.data!.docs[index]["id"],
                            snapshot.data!.docs[index]["role"]);
                      },
                      title: Text(snapshot.data!.docs[index]['name']),
                      subtitle: Text(snapshot.data!.docs[index]['email']),
                    )),
                  );
                });
          }
        });
  }

//
  bottomSheet(String id, String role) {
    Get.bottomSheet(BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: role == "Button" ? 180 : 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      showPopUp(context, id);
                    },
                    leading: Icon(Icons.person),
                    title: Text("Edit Name"),
                  ),
                  role == "Button"
                      ? ListTile(
                          onTap: () {
                            // Get.to(() => AssignDevice());
                            devicesPopup(context, id);
                          },
                          leading: Icon(Icons.devices),
                          title: Text("Assign devices"),
                        )
                      : Container(),
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

//PopUp for Edit Name
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

// Get all devices to assign
  devicesPopup(BuildContext context, String id) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Assign Devices"),
            content: Container(height: 150, child: getRingers(id)),
            actions: [
              Row(
                children: [

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

  // get All ringers inside popup
  getRingers(String id) {
    return StreamBuilder(
        stream: userRef.where("role", isEqualTo: "Ringer").snapshots(),
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
                  RxBool btnValue = false.obs;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3.0, vertical: 2),
                    child: Card(
                        child: ListTile(
                      onTap: () {},
                      title: Text(snapshot.data!.docs[index]['name']),
                      trailing: Obx(() => SlidingSwitch(
                            textOff: "",
                            textOn: "",
                            colorOn: Colors.deepPurple,
                            buttonColor: btnValue.value == true
                                ? Colors.deepPurple
                                : Colors.white,
                            height: 15,
                            width: 40,
                            value: btnValue.value,
                            onChanged: (bool value) {
                              btnValue.toggle();
                              ringerId = snapshot.data!.docs[index]['id'];
                              if (btnValue.value == true) {
                                // userRef.doc(snapshot.)
                                assignedDevices["id"] = id;
                                assignedDevices["ringer"] =
                                    snapshot.data!.docs[index]['id'];

                                update();
                                print(assignedDevices);
                                assignDevices(id);
                              } else {
                                unassignDevice(ringerId, id);
                              }
                            },
                            onTap: () {},
                            onDoubleTap: () {},
                            onSwipe: () {},
                          )),
                    )),
                  );
                });
          }
        });
  }

  unassignDevice(String ringerId, String buttonId)async{
    await userRef.doc(buttonId).collection('Assigned Devices').doc(ringerId).delete().then((value){
      EasyLoading.showSuccess("Device Removed!");
    }).onError((error, stackTrace) {
      EasyLoading.showError(error.toString());
      Get.back();

    });


  }
  getReminders() {
    return Flexible(
      child: StreamBuilder(
        stream: remindersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
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
                        TableCell(
                          child: Container(
                            height: 40,
                            child: Center(child: Text(snapshot.data!.docs[index]['name'])),
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

// assign device and store it to firebase
  assignDevices(String buttonId) {
    print("button Pressed!");
    userRef
        .doc(buttonId)
        .collection("Assigned Devices")
        .doc(ringerId)
        .set(assignedDevices)
        .then((value) {
      EasyLoading.showSuccess("Devices Assign Successfully");
    }).onError((error, stackTrace) {
      Get.snackbar(error.toString(), "");
    });
  }

//Update device name from firebase
  updateName(String id) {
    userRef.doc(id).update({"name": nameController.text}).then((value) {
      EasyLoading.showSuccess("Name Updated!");
      Get.back();
      Get.back();
      nameController.clear();
    });
  }

  // remove device
  removeDevice(String id) {
    userRef.doc(id).delete().then((value) {
      EasyLoading.showSuccess("Device Removed!");
      Get.back();
    });
    update();
  }

  logout() {
    EasyLoading.show(
      status: "Logging out, Please wait...",
    );
    auth.signOut().then((value) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Logout Successfully',
        '',
      );
      Get.off(LoginScreen());
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar('Error', error.toString(), backgroundColor: Colors.red);
    });
    update();
  }
}
