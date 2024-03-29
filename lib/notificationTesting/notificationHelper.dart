import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complete_women_care/AllText.dart';
import 'package:complete_women_care/screens/ChatScreen.dart';
import 'package:http/http.dart'as http;

import 'PushNotiication_service.dart';

class MyNotificationHelper {
  String title;
  String body;
  String payload;
  String id;
  String type;
  BuildContext context;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MyNotificationHelper() {
    initialize();
    print("\n\nPayload : $payload");
  }

  setPrefrenceBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  initialize() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

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

  showNotification(
      {String title,
      String body,
      String payload,
      String id,
      BuildContext context2}) async {
    context = context2;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      id,
      body,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        int.parse(id), title, body, platformChannelSpecifics,
        payload: payload);
  }

  Future<void> showMessagingNotification(
      {Map<String, dynamic> data, BuildContext context2}) async {
    context = context2;

    const Person me = Person(
      name: 'Me',
      key: '1',
      uri: 'tel:1234567890',
    );
    Person coworker = Person(
      name: data['myName'],
      key: '2',
      uri: 'tel:9876543210',
    );

    final List<Message> messages = List.generate(
        data['body'].toString().split("`").length,
        (index) => Message(data['body'].toString().split("`")[index],
            DateTime.now(), coworker));

    final MessagingStyleInformation messagingStyle = MessagingStyleInformation(
      me,
      groupConversation: true,
      htmlFormatContent: true,
      htmlFormatTitle: true,
      conversationTitle:
          data['body'].toString().split("`").length.toString() + " message",
      messages: messages,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "id",
      "name",
      category: 'msg',
      importance: Importance.max,
      groupKey: "CoolChat",
      setAsGroupSummary: true,
      styleInformation: messagingStyle,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(int.parse(data['channel']),
        data['title'], data['body'], platformChannelSpecifics,
        payload: data['title'] + "," + data['uid']);
  }

  Future<void> showInboxNotification(
      groupChannelId, groupChannelName, groupChannelDescription) async {
    final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName,
            styleInformation: inboxStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    print("Called");
    if (payload != null) {
      SharedPreferences.getInstance().then((value) {
        value.setString("payload", payload);
        print("0-> notificationHelper : ->${value.getString("payload")}");
      });
      print('\n\nnotification payload: $payload');
      Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (context) =>
                ChatScreen(payload.split(",")[0], payload.split(",")[1])),
      );
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future<void> showGroupedNotifications() async {
    const String groupKey = 'com.android.example.COOL_CHAT';
    const String groupChannelId = 'Cool Chat';
    const String groupChannelName = 'Cool Chat';
    const String groupChannelDescription = 'grouped channel description';

    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);

    const AndroidNotificationDetails secondNotificationAndroidSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey);
    const NotificationDetails secondNotificationPlatformSpecifics =
        NotificationDetails(android: secondNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    const List<String> lines = <String>[
      'Alex Faarborg  Check this out',
      'Jeff Chang    Launch Party',
      'Message    Launch Party'
    ];
    const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        htmlFormatContentTitle: true,
        contentTitle: '2 messages');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName,
            styleInformation: inboxStyleInformation,
            groupKey: groupKey,
            setAsGroupSummary: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two messages', platformChannelSpecifics);
  }
}
