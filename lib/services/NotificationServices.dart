import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//
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
      // AwesomeNotificationServices.showNotification(
      //     title: message.notification!.title.toString(),
      //     body: message.notification!.body.toString(),
      //     scheduled: true,
      //     interval: 15
      // // interval: 15
      // );
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

  notificationDetail() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(), 'Highly important channel',
        importance: Importance.max,
        showBadge: true ,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('success'));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker',
            sound: channel.sound);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    return notificationDetails;
  }

  showMessage(RemoteMessage message) async {
    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(duration * 1000);

    flutterLocalNotification.show(0, message.notification!.title.toString(),
        message.notification!.body.toString(), await notificationDetail() );
    // flutterLocalNotification.zonedSchedule(
    //     Random.secure().nextInt(10000),
    //     message.notification!.title.toString(),
    //     message.notification!.body.toString(),
    //     tz.TZDateTime.from(dateTime, tz.local)
    //     // tz.TZDateTime.now(tz.local).add(duration)
    //     ,
    //     await notificationDetail(),
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime);
  }

  sendNotification() async {
    flutterLocalNotification.show(0, "message.notification!.title.toString()",
        "message.notification!.body.toString()", await notificationDetail());
  }

////////////////////////////////////////////////////
//   setReminder() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'scheduled title',
//       'scheduled body',
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

  scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleNotificationDateTime}) async {
    print("Notification scheduled");
    flutterLocalNotification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
        await notificationDetail(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    print("Done!");
  }
}
