import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fw_vendor/controller/return_order_settlement_controller.dart';
import 'package:fw_vendor/core/configuration/app_routes.dart';
import 'package:fw_vendor/services/firbase/firbase_notification_service.dart';
import 'package:get/get.dart';

class NotificationManager {
  FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

  NotificationManager() {
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var settings = InitializationSettings(android: android, iOS: iOS);
    flip.initialize(settings, onSelectNotification: onSelectNotification);
  }

  Future createNotificationOrder(title, description, payload) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '150',
      'order_sound',
      // 'Order Notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      showWhen: true,
      subText: 'Need to respond',
      visibility: NotificationVisibility.public,
      enableVibration: true,
      tag: 'order',
      sound: RawResourceAndroidNotificationSound('whistle'),
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    var nPayload = json.encode(payload);
    await flip.show(0, title, description, platformChannelSpecifics, payload: nPayload);
  }

  Future showNormalNotification(title, description, payload) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '160',
      'normal_sound',
      // 'Normal Notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      showWhen: true,
      visibility: NotificationVisibility.public,
      enableVibration: true,
      tag: 'normal',
      sound: RawResourceAndroidNotificationSound('normal'),
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    var nPayload = json.encode(payload);
    await flip.show(1, title, description, platformChannelSpecifics, payload: nPayload);
  }

  Future<dynamic> onSelectNotification(String? data) {
    dynamic datas = data;
    if (datas != null && datas != "") {
      var nData = json.decode(datas);
      if (nData!['screen'] == "/home") {
        Get.to(() => FirebaseNotificationService(), arguments: nData);
      }
      if (nData!['screen'] == "/returnSettlementScreen") {
        if (!Get.isRegistered<ReturnOrderSettlementController>()) {
          Get.toNamed(AppRoutes.returnSettlementScreen);
        }
      }
    }
    return datas;
  }
}
