import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

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
      print("FCM token: $token");
      return token;
    } catch (error) {
      log("Error fetching FCM token: $error");
      try {
        final String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          token = apnsToken;
        }
        log("APNs token: $apnsToken");
        return apnsToken;
      } catch (apnsError) {
        log("Error fetching APNs token: $apnsError");
        return null;
      }
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
