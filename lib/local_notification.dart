import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_motion/screen.dart';

class LocalNotifications extends StatefulWidget {
  final String title;

  LocalNotifications({required this.title});

  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    var androidSettings = AndroidInitializationSettings('app_icon');

    var initSetttings = InitializationSettings(
      android: androidSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onClickNotification);
  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future? onClickNotification(String? payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return DestinationScreen(
        payload: payload!,
      );
    }));
  }

  Future<void> showSimpleNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'id',
      'channel ',
      priority: Priority.high,
      importance: Importance.max,
      icon: 'app_icon',
    );
    var iOSDetails = IOSNotificationDetails();
    var platformDetails = new NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification',
        'Flutter Simple Notification', platformDetails,
        payload: 'Destination Screen (Simple Notification)');
  }

  Future<void> showScheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(const Duration(seconds: 10));
    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var platformDetails = NotificationDetails(
      android: androidDetails,
    );
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Flutter Local Notification',
        'Flutter Schedule Notification',
        scheduledNotificationDateTime,
        platformDetails,
        payload: 'Destination Screen(Schedule Notification)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: TextButton(
                  child: Text(
                    'Simple Notification',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => showSimpleNotification(),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: TextButton(
                  child: Text(
                    'Schedule Notifications 10 Detik',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => showScheduleNotification(),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
