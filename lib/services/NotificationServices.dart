import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService{
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
// String? deviceToken;
//
//   getDeviceToken()async{
//     String? token = await messaging.getToken();
//     if(kDebugMode){
//       print(token);
//     }
//     return token;
//   }
//
//   isTokenRefreshed(){
//     messaging.onTokenRefresh.listen((event) {
//       deviceToken = event;
//     });
//
//   }
//
//
// }


class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotification =
  FlutterLocalNotificationsPlugin();
//Request permissions
  requestNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        sound: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted Permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provincial Permission');
      }
    } else {
      if (kDebugMode) {
        print('User denied Permission');
      }
    }
  }

//get token
  getDeviceToken() async {
    String? token = await messaging.getToken();
    if (kDebugMode) {
      print(token!);
    }
    return token!;
  }

//get refreshed token
  isTokenRefreshed() {
    messaging.onTokenRefresh.listen((value) {
      String token = value;
    });
  }

  firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());

      showMessage(message);
      initLocalNotification(message);
    });

  }

  initLocalNotification(RemoteMessage message) {
    final androidInitialization =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosInitialization = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: androidInitialization, iOS: iosInitialization);
    flutterLocalNotification.initialize(initializationSettings);
  }

  showMessage(RemoteMessage message) {
    AndroidNotificationChannel channel =  AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(), 'high importance channel',
        importance: Importance.max,
        // showBadge: true ,
        // playSound: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(channel.id, channel.name,
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        sound: channel.sound);

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    flutterLocalNotification.show(0, message.notification!.title.toString(),
        message.notification!.body.toString(), notificationDetails);
  }
}
