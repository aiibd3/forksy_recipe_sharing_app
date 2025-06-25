import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> notificationBadgeCount(int count) async {
    await AwesomeNotifications().setGlobalBadgeCounter(count);
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    // if (payload["navigate"] == "true") {
    //   MyApp.navigatorKey.currentState?.push(
    //     MaterialPageRoute(
    //       builder: (_) =>  MyApp(),
    //     ),
    //   );
    // }
    if (payload["cancel"] == "true") {}
  }

  /// to show No notification
  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.BigPicture,
    final NotificationCategory? category,
    final String? bigPicture,
    final String? largeIcon,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
    final double? progress,
    final int id = 1,
    final bool locked = false,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        displayOnBackground: true,
        displayOnForeground: true,
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        // largeIcon: largeIcon,
        progress: progress,
        locked: locked,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: Duration(seconds: interval ?? 0),
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await AwesomeNotifications().cancelAllSchedules();
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      await AwesomeNotifications().cancelAll();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> cancelNotification({int id = 1}) async {
    try {
      await AwesomeNotifications().cancel(id);
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      await AwesomeNotifications().cancelSchedule(id);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
