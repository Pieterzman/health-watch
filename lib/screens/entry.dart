import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../api/notification_api.dart';
import '../models/ModelProvider.dart';
import '../widgets/login.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

enum AppState { GETTING_PREV_SESSION, LOGIN }

class _EntryScreenState extends State<EntryScreen> {
  AppState _state = AppState.GETTING_PREV_SESSION;
  String? wifiIP;

  @override
  void initState() {
    super.initState();
    tzsetup();
    scheduleNotifications();
    // getWifiDetails();
    // Future.delayed(Duration(milliseconds: 700), () {
    checkUserLogin();
    // fetchSession();
    // });
  }

  // Future<void> getWifiDetails() async {
  //   try {
  //     final info = NetworkInfo();
  //     wifiIP = await info.getWifiIP();
  //     print(wifiIP);

  //     if (wifiIP != null) {
  //       writeWifiData(wifiIP!);
  //     }
  //   } catch (e) {
  //     throw e;
  //   }
  // }

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
    // DateTime now = DateTime.now();
    // DateTime today = DateTime(now.year, now.month, now.day);
    // DateTime nine_O_clock_tomorrow = today.add(Duration(days: 1, hours: 9));
    // print(nine_O_clock_tomorrow);

    // NotificationApi.cancelAll();
    await FlutterLocalNotificationsPlugin().cancelAll();
    print('Notifications Cancelled');

    NotificationApi.showScheduledNotification(
        title: 'Hey User',
        body: 'Please remember to log your most recent data.',
        // scheduledDate: now.add(Duration(days: 0, seconds: 10))
        scheduledDate: DateTime.now());

    print('Notifications scheduled');
  }

  Future<void> checkUserLogin() async {
    setState(() => _state = AppState.GETTING_PREV_SESSION);
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString("userEmail");
    final userLoggedIn = prefs.getBool("userLoggedIn");
    AuthSession? res;
    // AuthSession? currentSession;

    // try {
    //   currentSession = await Amplify.Auth.curr
    // } on AuthException catch (e) {
    //   print(e.message);
    // }

    try {
      res = await Amplify.Auth.fetchAuthSession(
              options: CognitoSessionOptions(getAWSCredentials: false))
          .timeout(const Duration(seconds: 5));
    } on AuthException catch (e) {
      print(e.message);
    } on TimeoutException {
      print("Internet timed out, switching to offline mode");
      //checkUserLogin();
    }

    if (userEmail != null && userLoggedIn == true && res!.isSignedIn == true) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else
      setState(() => _state = AppState.LOGIN);
  }

  // Future<void> fetchSession() async {
  //   try {
  //     AuthSession res = await Amplify.Auth.fetchAuthSession(
  //             options: CognitoSessionOptions(getAWSCredentials: false))
  //         .timeout(const Duration(seconds: 10));

  //     if (res.isSignedIn == true) {
  //       Navigator.pushReplacementNamed(context, '/dashboard');
  //     }
  //     // else
  //     //   return;
  //   } on AuthException catch (e) {
  //     print(e.message);
  //   } on TimeoutException {
  //     throw ("Internet timed out, switching to offline mode");
  //     //checkUserLogin();
  //   }
  // }

  // Future<void> writeWifiData(String wifiIP) async {
  //   HealthDataUser? currentHealthDataUser;
  //   DateTime now = DateTime.now();

  //   /// Get HealthDataUser
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final uuid = prefs.getString("useruuid");

  //     currentHealthDataUser = (await Amplify.DataStore.query(
  //         HealthDataUser.classType,
  //         where: HealthDataUser.USERUUID.eq(uuid)))[0];
  //   } catch (e) {
  //     print("caught exception in getting currentHealthDatauser");
  //   }

  //   ///Save WifiIP to DataStore
  //   try {
  //     WifiPt newWifiPt = WifiPt(
  //         healthdatauserID: currentHealthDataUser!.id,
  //         loggedWifiIP: wifiIP,
  //         loggedDate: TemporalDateTime(now));

  //     await Amplify.DataStore.save(newWifiPt);
  //     print("Created: $newWifiPt");
  //   } catch (e) {
  //     print("Caught exception in saving newWifiPt: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(36, 38, 94, 1),
      body: Center(
        child: _state == AppState.LOGIN
            ? Login()
            : const Image(
                image: AssetImage("assets/app_icon.png"),
                alignment: Alignment.center,
                width: 300,
              ),
      ),
    );
  }
}
