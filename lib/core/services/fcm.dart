// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
//
// class Fcm {
//   static FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   static Future<void> fcmInit() async {
//     requestPermissionForIos();
//     getToken();
//     onForeground();
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
//   static Future<void> requestPermissionForIos() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//   }
//
//   static Future<String?> getToken() async {
//     String? token = await messaging.getToken();
//     return token;
//   }
//
//   static Future<void> onForeground() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//       'This channel is used for important notifications.', // description
//       importance: Importance.max,
//     );
//
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 icon: "ic_launcher",
//               ),
//             ));
//       }
//     });
//   }
// }










import 'dart:developer';

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
      LogsManager.warning('FCM token: $token');
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
