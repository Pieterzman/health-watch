import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../api/notification_api.dart';
import '../widgets/login.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    tzsetup();
    scheduleNotifications();
    Future.delayed(Duration(milliseconds: 700), () {
      checkUserLogin();
    });
  }

  Future<void> tzsetup() async {
    try {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
      NotificationApi.init(initScheduled: true);
    } catch (e) {
      print("failed to setup timezone");
    }
  }

  void scheduleNotifications() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime nine_O_clock_tomorrow = today.add(Duration(days: 1, hours: 9));
    print(nine_O_clock_tomorrow);

    NotificationApi.cancelAll();

    NotificationApi.showScheduledNotification(
        title: 'Hey User',
        body: 'Please remember to log your most recent data.',
        // scheduledDate: now.add(Duration(days: 0, seconds: 10))
        scheduledDate: now);

    print('Notifications scheduled');
  }

  Future<void> checkUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString("userEmail");
    final userLoggedIn = prefs.getBool("userLoggedIn");

    if (userEmail != null && userLoggedIn == true) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(36, 38, 94, 1),
      body: Center(
        child: Login(),
      ),
    );
  }
}
