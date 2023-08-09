import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> backgroundMessage(RemoteMessage message) async {
  print(message);

}
String fcmToken = "";

class PushNotificationService {
  final BuildContext context;

  PushNotificationService({this.context});

  Future initialise() async {
    iOSPermission();
    messaging.getToken().then((token) async {
      fcmToken = token.toString();
      print("fcmToken---"+fcmToken);
    });
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("0k Push Notification======"+message.toString());
      var data = message.notification;
      print("cehed===="+data.toString());

      var title = data.title.toString();
      print("newwwww=======" + title);
      var body = data.body.toString();
      var image = message.data['image'] ?? '';
      print("check"+image);
      var type = message.data['type'] ?? '';
      var id = '';
      id = message.data['type_id'] ?? '';
      if (image != null && image != 'null' && image != '') {
        generateImageNotication(title, body, image, type, id);
      } else {
        generateSimpleNotication(title, body, type, id);
      }
      /* if (type == "ticket_status") {

      } else if (type == "ticket_message") {

          if (image != null && image != 'null' && image != '') {
            generateImageNotication(title, body, image, type, id);
          } else {
            generateSimpleNotication(title, body, type, id);
          }
      } else if (image != null && image != 'null' && image != '') {
        generateImageNotication(title, body, image, type, id);
      } else {
        generateSimpleNotication(title, body, type, id);
      }*/
    });

    messaging.getInitialMessage().then((RemoteMessage message) async {
      await Future.delayed(Duration.zero);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

    });
  }

  void iOSPermission() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

// class PushNotificationService {
//   BuildContext context;
//   ValueChanged onResult;
//   String? type;
//   PushNotificationService({required this.context,required this.onResult, this.type});
//
//   var test;
//
//   Future initialise() async {
//     await App.init();
//     iOSPermission();
//     messaging.getToken().then((token) async {
//       fcmToken = token;
//     });
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('ic_launcher');
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings();
//     final MacOSInitializationSettings initializationSettingsMacOS =
//     MacOSInitializationSettings();
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//         macOS: initializationSettingsMacOS);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//           print("this is notification data ${payload.toString()}");
//           if(type == "2"|| type =="3" || type =="4") {
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => BottomBarDelivery(bookingId: test['Booking_id'])),
//                     (route) => false);
//           }else{
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => BottomBar(bookingId: test['Booking_id'])),
//                     (route) => false);
//           }
//         });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       App.localStorage.setBool("notStatus", true);
//       notificationStatus = App.localStorage.getBool("notStatus")!;
//       print("0k" + message.toString());
//       var data = message.notification!;
//       var title = data.title.toString();
//       var body = data.body.toString();
//       test = message.data;
//       print('this is booking ID =====> ${test['Booking_id']}');
//       bookingId = test['Booking_id'];
//       if(title.toString().contains("update")){
//         onResult("update");
//       }else  if(title.toString().contains("cancelled")){
//         onResult("cancelled");
//       } else{
//         onResult(bookingId);
//       }
//       /* if(bookingId==""){
//         bookingId = test['Booking_id'];
//         print("okay");
//         onResult(bookingId);
//      */
//       /*   Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => OfflinePage(test['Booking_id'])),
//                 (route) => false);*/
//       /*
//       }else{
//         if(bookingId==test['Booking_id']){
//           print("no");
//         }else{
//           bookingId = test['Booking_id'];
//           onResult(bookingId);
//         }
//       }*/
//       print(test);
//       var image = message.data['image'] ?? '';
//       print(image);
//       var type = message.data['type'] ?? '';
//       var id = '';
//       id = message.data['type_id'] ?? '';
//       if (image != null && image != 'null' && image != '') {
//         generateImageNotication(title, body, image, type, bookingId);
//       } else {
//         generateSimpleNotication(title, body, type, bookingId);
//         // createSimpleNotication(title, body, type, id, test);
//       }
//     });
//
//     messaging.getInitialMessage().then((RemoteMessage? message) async {
//       await Future.delayed(Duration.zero);
//     });
//
//     FirebaseMessaging.onBackgroundMessage(backgroundMessage);
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var test = message.data;
//       print(test);
//       /*  bookingId = test['Booking_id'];
//       onResult(bookingId);*/
//       //onResult(bookingId);
//     });
//   }
//
//   void iOSPermission() async {
//     await messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
// }

Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {
  return Future<void>.value();
}

Future<String> _downloadAndSaveImage(String url, String fileName) async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/$fileName';
  var response = await http.get(Uri.parse(url));

  var file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> generateImageNotication(
    String title, String msg, String image, String type, String id) async {
  var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
  var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
  var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: msg,
      htmlFormatSummaryText: true);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',

    // channelDescription:'your channel description',
    ongoing: true,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
    styleInformation: bigPictureStyleInformation,
    playSound: true,
    sound: const UriAndroidNotificationSound("assets/sms tone.mp3"),
  );
  var platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, msg, platformChannelSpecifics, payload: type + "," + id);
}

Future<void> generateSimpleNotication(
    String title, String msg, String type, String id) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel', 'High Importance Notifications',
      //channelDescription: 'your channel description',
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      ticker: 'ticker');
  var iosDetail = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iosDetail);
  await flutterLocalNotificationsPlugin
      .show(0, title, msg, platformChannelSpecifics, payload: type + "," + id);
}
