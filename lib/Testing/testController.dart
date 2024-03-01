import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart'as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:qr_code/services/NotificationServices.dart';

class TestController extends GetxController {
 NotificationService service = NotificationService();

 send(){
  service.getDeviceToken().then((value){
    sendNotification(value);
  });
  update();
 }
 sendNotification(String token) async {
   service.getDeviceToken().then((value) async {
     var data = {
       'to': token,
       'priority': 'high',
       'notification': {
         'title': "New Notification!",
         'body': "from:",
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
}
