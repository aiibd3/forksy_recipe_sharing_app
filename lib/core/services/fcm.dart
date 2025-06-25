import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:forksy/core/utils/logs_manager.dart';

import 'notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class Fcm {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future<void> fcmInit() async {
    await NotificationService.initializeNotification();
    await requestPermissionForIos();
    getToken();
    onForeground();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> requestPermissionForIos() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<String?> getToken() async {
    try {
      token = await messaging.getToken();
      if (token != null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'fcmToken': token});
          LogsManager.info("FCM token saved for user $uid: $token");
        } else {
          LogsManager.error("No authenticated user found to save FCM token");
        }
      }
      LogsManager.warning("FCM token: $token");
      return token;
    } catch (e) {
      LogsManager.error("Error fetching or saving FCM token: $e");
      return null;
    }
  }

  static Future<void> onForeground() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("onMessage: $message");
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        await NotificationService.showNotification(
          title: notification.title ?? "",
          body: notification.body ?? "",
          bigPicture: notification.android?.imageUrl,
          // largeIcon: notification.android?.imageUrl,
        );
      } else {
        await NotificationService.showNotification(
          title: notification?.title ?? "",
          body: notification?.body ?? "",
          bigPicture: notification?.apple?.imageUrl,
          // largeIcon: notification?.apple?.imageUrl,
        );
      }
    });
  }
}
