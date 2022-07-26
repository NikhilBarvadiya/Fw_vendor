// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fw_vendor/controller/app_controller.dart';
import 'package:get/get.dart';
import 'firbase_config.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseNotificationService {
  static Future<bool> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseConfig.platformOptions,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    return true;
  }

  setup() {
    initNotification();
  }

  Future<void> initNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _notificationNavigateToItemDetail(message.data);
      }
    });

    Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {}

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_notification');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (val) async {
      if (val != null && val.isNotEmpty) {
        dynamic data = jsonDecode(val);
        _notificationNavigateToItemDetail(data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      if (!kIsWeb && notification != null) {
        String? channelId;
        channelId = message.notification!.android?.channelId;

        String? currentRoute = Get.currentRoute;
        if (currentRoute != null && currentRoute.contains('messenger')) {
        } else {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId ?? channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'ic_notification',
                color: AppController().appTheme.secondary,
              ),
              iOS: const IOSNotificationDetails(),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationNavigateToItemDetail(message.data);
    });

    getToken();
  }

  void _notificationNavigateToItemDetail(dynamic data) async {
    if (!data.isNullOrBlank) {
      if (data["screen"] != null) {
        if (data["data"] != null) {
          var newData;
          if (data["data"] is String) {
            newData = jsonDecode(data["data"]);
          } else {
            newData = data["data"];
          }
          Get.toNamed('/' + data["screen"], arguments: newData);
        } else {
          Get.toNamed('/' + data['screen']);
        }
      }
    }
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
  }

  requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
