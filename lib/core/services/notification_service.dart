import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_config.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  final String _projectId = AppConfig.projectId;

  Future<void> initialize() async {
    // 1. Initialize Local Notifications for Foreground display
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(settings: initializationSettings);

    // 2. Request FCM permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Permission granted
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Listen to Foreground messages and trigger Local Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'd_chat_channel',
      'D-chat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    final chatId = message.data['chatId'] ?? 'default';

    await _localNotifications.show(
      id: chatId.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  Future<String> _getAccessToken() async {
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(AppConfig.fcmServiceAccount);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await auth.clientViaServiceAccount(accountCredentials, scopes);
    final token = client.credentials.accessToken.data;
    client.close();
    return token;
  }

  Future<void> sendPushNotification({
    required String recipientToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      final url = Uri.parse('https://fcm.googleapis.com/v1/projects/$_projectId/messages:send');

      final payload = {
        "message": {
          "token": recipientToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            ...?data,
            "chatId": data?['chatId'] ?? "",
          },
        }
      };
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );
    } catch (e) {
      debugPrint('sendPushNotification Error: $e');
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}
