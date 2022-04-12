import 'dart:async';
import 'dart:io' show Platform;
// import 'dart:ui' as ui;
import 'package:amplify_datastore/amplify_datastore.dart';
// import 'package:fluomatic/api/notification_api.dart';
// import 'package:fluomatic/models/ModelProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:healthwatch/api/notification_api.dart';
import 'package:healthwatch/models/ModelProvider.dart';
import 'package:healthwatch/widgets/terms_of_use.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/health.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  // LOG_DEMOGRAPHIC_DATA,
  USER_OPTED_OUT
}

class _DashboardScreenState extends State<DashboardScreen> {
  AuthUser? _user;
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> _healthDataList = [];
  List<HealthDataPt>? _datastoreHealthDataList = [];
  HealthDataUser? currentHealthDataUser;
  bool? optedOut;
  // bool? notificationsFlag;
  // bool? alreadyScheduled;

  ///dashboard variables
  int? dailySteps;
  double? dailySleepDuration;
  double? dailyInBedDuration;
  double? latestHeartRatePoint;
  double? avgDailyRestingHR;
  double? avgDailyHRVariability;
  AppState _state = AppState.DATA_NOT_FETCHED;

  // bool demographicDataLogged = false;
  // bool _isBox1Elevated = false;

  @override
  void initState() {
    super.initState();
    Amplify.Auth.getCurrentUser().then((user) {
      setState(() {
        _user = user;
        // tzsetup();
        // scheduleNotifications();
        getCurrentHealthDataUser();
        fetchData();
      });
    }).catchError((error) {
      print((error as AuthException).message);
    });

    // NotificationApi.showScheduledNotification(scheduledDate: DateTime.now());
    // print('Notifications scheduled');
    // notificationsFlag = true;
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
    NotificationApi.cancelAll();
    NotificationApi.showScheduledNotification(
        title: 'Hey User',
        body: 'Please remember to log your most recent data.',
        scheduledDate: DateTime.now());
    print('Notifications scheduled');
  }

  Future<HealthDataUser?> getCurrentHealthDataUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getString("useruuid");

      currentHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(uuid)))[0];
      return currentHealthDataUser;
    } catch (e) {
      print("caught exception in getCurrentHealthDataUser");
    }
  }

  Future fetchData() async {
    HealthDataUser? currentuser = await getCurrentHealthDataUser();
    // currentuser = currentHealthDataUser;
    // final Future<String?> useruuid = getUserUUID();
    final prefs = await SharedPreferences.getInstance();
    final useruuid = prefs.getString("useruuid");
    final lastrefreshed = prefs.getString("lastrefreshed");
    // bool demographicDataLogged = prefs.getBool("demographicDataLogged")!;
    DateTime lastRefreshed1 = DateTime.parse(lastrefreshed!);
    DateTime? lastRefreshed2 = await getLastRefreshed2(useruuid!);
    optedOut = prefs.getBool('opt_out');
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    if (lastRefreshed2 != lastRefreshed1) {
      print("last refreshed times not the same");
    }

    DateTime startDate = lastRefreshed1;
    DateTime endDate = DateTime.now().toUtc();

    // HealthFactory health = HealthFactory();

    List<HealthDataType>? types;
    List<HealthDataAccess>? permissions;

    /// Define the types to get.
    if (Platform.isAndroid) {
      types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        // HealthDataType.RESTING_HEART_RATE,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP
      ];
      permissions = [
        HealthDataAccess.READ,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
      ];
    } else if (Platform.isIOS) {
      types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.RESTING_HEART_RATE,
        HealthDataType.HEART_RATE_VARIABILITY_SDNN,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP
      ];
      permissions = [
        HealthDataAccess.READ,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
        HealthDataAccess.READ,
      ];
    }

    // if (demographicDataLogged == true) {
    //   setState(() => _state = AppState.FETCHING_DATA);
    // } else {
    //   setState(() => _state = AppState.LOG_DEMOGRAPHIC_DATA);
    // }

    // if (optedOut == true) {
    //   setState(() {
    //     _state = AppState.USER_OPTED_OUT;
    //   });
    // } else {
    setState(() => _state = AppState.FETCHING_DATA);
    // }

    /// You MUST request access to the data types before reading them
    if (Platform.isAndroid) {
      final permissionStatus = await Permission.activityRecognition.request();
      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        setState(() {
          AppState.AUTH_NOT_GRANTED;
        });
      }
    }
    // PermissionStatus activityrecognitionGranted =
    //     await Permission.activityRecognition.request();

    bool accessWasGranted =
        await health.requestAuthorization(types!, permissions: permissions!);

    // if (currentuser!.opt_out == false) {
    if (accessWasGranted && optedOut == false) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points //////////////////////////////////////////////////////////////////   OPTIMIZE
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      if (_healthDataList.isNotEmpty) {
        /// Filter out duplicates

        // _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

        ///Sort and Find most recent datapoint
        _healthDataList.sort((a, b) => a.dateTo.compareTo(b.dateTo));

        /// Find and save last refreshed
        HealthDataPoint lastHealthDataPoint = _healthDataList.last;
        DateTime lastHealthDataPointDate = lastHealthDataPoint.dateTo.toUtc();
        lastHealthDataPointDate =
            lastHealthDataPointDate.add(const Duration(milliseconds: 1));

        prefs.setString(
            'lastrefreshed', lastHealthDataPointDate.toIso8601String());
        updateLastRefreshed2(TemporalDateTime(lastHealthDataPointDate));

        /// Save Data to DataStore

        _healthDataList.forEach((x) async {
          TemporalDateTime temporalDateTimeFrom = TemporalDateTime(x.dateFrom);
          TemporalDateTime temporalDateTimeTo = TemporalDateTime(x.dateTo);
          writeDatastore(
              currentuser,
              x.typeString,
              x.value.toDouble(),
              x.unitString,
              x.sourceId,
              temporalDateTimeFrom,
              temporalDateTimeTo);
        });
      }

      dailySteps = await health.getTotalStepsInInterval(startOfDay, endOfDay);

      await fetchDailySleep(now);
      await fetchDailyHeartRate(startOfDay, endOfDay);

      if (Platform.isIOS) {
        await fetchDailyRestingHeartRate(startOfDay, endOfDay);
        await fetchDailyHeartRateVariability(startOfDay, endOfDay);
      }

      /// Get HealthData from DataStore
      _datastoreHealthDataList = await readDatastore(currentuser);

      // updateLastRefreshed2(TemporalDateTime(lastHealthDataPt));
      _healthDataList.clear();
      // print(_datastoreHealthDataList?.length);

      /// Update the UI to display the results
      ///

      setState(() {
        _state = _datastoreHealthDataList!.isEmpty
            ? AppState.NO_DATA
            : AppState.DATA_READY;
      });

      ///
    } else if (!accessWasGranted && optedOut == false) {
      print("Authorization not granted");
      setState(() => _state = AppState.AUTH_NOT_GRANTED);
    } else if (optedOut == true) {
      setState(() => _state = AppState.USER_OPTED_OUT);
    }
    // } else {
    //   print("User Opted out of the study");
    //   setState(() => _state = AppState.DATA_NOT_FETCHED);
    // }
  }

  Future fetchDailySleep(DateTime now) async {
    DateTime endOfSleepDay = DateTime(now.year, now.month, now.day, 19);
    DateTime startOfSleepDay = endOfSleepDay.subtract(Duration(days: 1));
    String? firstSleepSourceName;
    String? firstInBedSourceName;
    double dailySleep = 0;
    double dailyInBed = 0;

    try {
      List<HealthDataPoint> dailySleepPoints = await health
          .getHealthDataFromTypes(
              startOfSleepDay, endOfSleepDay, [HealthDataType.SLEEP_ASLEEP]);

      List<HealthDataPoint> dailyInBedPoints = await health
          .getHealthDataFromTypes(
              startOfSleepDay, endOfSleepDay, [HealthDataType.SLEEP_IN_BED]);

      // dailySleepPoints = HealthFactory.removeDuplicates(dailySleepPoints);
      // dailyInBedPoints = HealthFactory.removeDuplicates(dailyInBedPoints);
      if (dailySleepPoints.isNotEmpty) {
        firstSleepSourceName = dailySleepPoints.first.sourceName;

        dailySleepPoints.forEach((element) {
          if (element.sourceName == firstSleepSourceName) {
            dailySleep = dailySleep.ceilToDouble() + element.value;
          }
        });
      } else {
        dailySleep = 0;
      }

      if (dailyInBedPoints.isNotEmpty) {
        firstInBedSourceName = dailyInBedPoints.first.sourceName;

        dailyInBedPoints.forEach((element) {
          if (element.sourceName == firstInBedSourceName) {
            dailyInBed += element.value;
          }
        });
      }

      dailySleepDuration = dailySleep;
      dailyInBedDuration = dailyInBed;
    } catch (error) {
      print("Caught exception in getting Daily Steps");
    }
  }

  Future fetchDailyHeartRate(DateTime startOfDay, DateTime endOfDay) async {
    try {
      double? HRP = 0;
      List<HealthDataPoint> dailyHeartRatePoints = await health
          .getHealthDataFromTypes(
              startOfDay, endOfDay, [HealthDataType.HEART_RATE]);

      dailyHeartRatePoints.sort((a, b) => a.dateTo.compareTo(b.dateTo));

      dailyHeartRatePoints.forEach((element) {
        HRP = element.value as double?;
      });
      latestHeartRatePoint = HRP;
    } catch (error) {
      print('Caught exception in getting Daily Heart Rate');
    }
  }

  Future fetchDailyRestingHeartRate(
      DateTime startOfDay, DateTime endOfDay) async {
    double dailyRestingHeartRate = 0;

    try {
      List<HealthDataPoint> dailyRestingHeartRatePoints = await health
          .getHealthDataFromTypes(
              startOfDay, endOfDay, [HealthDataType.RESTING_HEART_RATE]);

      dailyRestingHeartRatePoints.forEach((element) {
        dailyRestingHeartRate = (dailyRestingHeartRate + element.value) /
            dailyRestingHeartRatePoints.length;
      });
      avgDailyRestingHR = dailyRestingHeartRate;
    } catch (error) {
      print('caught error while fetching daily resting heart rate');
    }
  }

  Future fetchDailyHeartRateVariability(
      DateTime startOfDay, DateTime endOfDay) async {
    double? HRVP = 0;

    try {
      List<HealthDataPoint> dailyHeartRateVariabilityPoints = await health
          .getHealthDataFromTypes(startOfDay, endOfDay,
              [HealthDataType.HEART_RATE_VARIABILITY_SDNN]);

      dailyHeartRateVariabilityPoints
          .sort((a, b) => a.dateTo.compareTo(b.dateTo));
      dailyHeartRateVariabilityPoints.forEach((element) {
        HRVP = element.value as double?;
      });

      avgDailyHRVariability = HRVP;
    } catch (error) {
      print('caught error while fetching daily heart ratevariability');
    }
  }

  /// Write Health Data to Local Datastore
  Future<void> writeDatastore(
      HealthDataUser? currentuser,
      String type,
      double val,
      String unit,
      String sourceid,
      TemporalDateTime datefrom,
      TemporalDateTime dateto) async {
    try {
      HealthDataPt newHealthDataPt = HealthDataPt(
          healthdatauserID: currentuser!.id,
          typeString: type,
          value: val,
          unitString: unit,
          sourceID: sourceid,
          dateFrom: datefrom,
          dateTo: dateto);
      await Amplify.DataStore.save(newHealthDataPt);
      // print("Saved: $newHealthDataPt");
    } catch (e) {
      print("Caught exception in getHealthDataFromTypes: $e");
    }
  }

  ///Read Data from Local Datastore
  Future<List<HealthDataPt>?> readDatastore(HealthDataUser? currentuser) async {
    try {
      List<HealthDataPt> healthdatapts = await Amplify.DataStore.query(
          HealthDataPt.classType,
          where: HealthDataPt.HEALTHDATAUSERID.eq(currentuser!.id),
          pagination: new QueryPagination(page: 0, limit: 10000),
          sortBy: [HealthDataPt.DATETO.descending()]);
      return healthdatapts;
    } on DataStoreException catch (e) {
      print("Query failed: $e");
      return null;
    }
  }

  /// Delete Data from Local Datastore
  Future<void> deleteDatastore(HealthDataUser currentuser) async {
    (await Amplify.DataStore.query(HealthDataPt.classType,
            pagination: new QueryPagination(page: 0, limit: 1000000),
            where: HealthDataPt.HEALTHDATAUSERID.eq(currentuser.id)))
        .forEach((element) async {
      try {
        await Amplify.DataStore.delete(element);
        // print("Deleted: $element");
      } on DataStoreException catch (e) {
        print("Delete Failed: $e");
      }
    });

    (await Amplify.DataStore.query(SymptomPt.classType,
            pagination: new QueryPagination(page: 0, limit: 1000000),
            where: SymptomPt.HEALTHDATAUSERID.eq(currentuser.id)))
        .forEach((element) async {
      try {
        await Amplify.DataStore.delete(element);
        print("Deleted: $element");
      } on DataStoreException catch (e) {
        print("Delete Failed: $e");
      }
    });

    (await Amplify.DataStore.query(IllnessPt.classType,
            pagination: new QueryPagination(page: 0, limit: 1000000),
            where: IllnessPt.HEALTHDATAUSERID.eq(currentuser.id)))
        .forEach((element) async {
      try {
        await Amplify.DataStore.delete(element);
        print("Deleted: $element");
      } on DataStoreException catch (e) {
        print("Delete Failed: $e");
      }
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('demographicDataLogged', false);
  }

  /// Update LastRefreshed Date
  Future<void> updateLastRefreshed2(TemporalDateTime lastrefreshed) async {
    final prefs = await SharedPreferences.getInstance();
    final useruuid = prefs.getString("useruuid");
    try {
      HealthDataUser oldHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(useruuid)))[0];
      // print(oldHealthDataUser);

      HealthDataUser newHealthDataUser = oldHealthDataUser.copyWith(
          id: oldHealthDataUser.id,
          useruuID: oldHealthDataUser.useruuID,
          lastSignedIn: oldHealthDataUser.lastSignedIn,
          lastRefreshed: lastrefreshed);
      // print(newHealthDataUser);

      await Amplify.DataStore.save(newHealthDataUser);
      print("Last Refresh Date 2 Updated: $lastrefreshed");
    } catch (e) {
      print("Couldnt update Last Refreshed Date");
    }
  }

  Future<void> resetLastRefreshed1() async {
    DateTime today = DateTime.now().toUtc();
    DateTime thirtyDaysAgo = today.subtract(const Duration(days: 1));
    String lastrefreshed = thirtyDaysAgo.toIso8601String();
    // String lastrefreshed = today.toIso8601String();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastrefreshed', lastrefreshed);
    print("Last Refresh Date 1 Updated $lastrefreshed");

    updateLastRefreshed2(TemporalDateTime(thirtyDaysAgo));
  }

  Future<DateTime?> getLastRefreshed2(String uuid) async {
    try {
      HealthDataUser aHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(uuid)))[0];

      TemporalDateTime lastrefreshed = aHealthDataUser.lastRefreshed;
      return lastrefreshed.getDateTimeInUtc();
    } catch (e) {
      print("Error: $e");
    }
  }

  /// Clear Data from Datastore
  Future<void> clearDatastore() async {
    await Amplify.DataStore.clear();
  }

  Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail');
    prefs.remove('userLoggedIn');
  }

  Future<void> optOut(bool optout) async {
    final prefs = await SharedPreferences.getInstance();
    final useruuid = prefs.getString('useruuid');
    prefs.setBool('opt_out', optout);
    optedOut = optout;

    try {
      HealthDataUser oldHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(useruuid)))[0];

      HealthDataUser newHealthDataUser = oldHealthDataUser.copyWith(
          id: oldHealthDataUser.id,
          useruuID: oldHealthDataUser.useruuID,
          lastSignedIn: oldHealthDataUser.lastSignedIn,
          lastRefreshed: oldHealthDataUser.lastRefreshed,
          opt_out: optout);
      // print(newHealthDataUser);

      await Amplify.DataStore.save(newHealthDataUser);
    } catch (e) {
      print("Couldnt update Opt_Out");
    }
  }

  // Future<void> saveNotificationsFlag(bool flagValue) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('notificationsFlag', flagValue);
  // }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return RefreshIndicator(
      strokeWidth: 3,
      backgroundColor: Color.fromRGBO(36, 38, 94, 1),
      color: Color.fromRGBO(106, 195, 163, 1),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          Center(
              child: const Text(
            '--- Pull down to refresh ---',
            style: TextStyle(color: Colors.black45),
          )),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(10),
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: const Offset(0, 0),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Total datapoints logged:',
                      style: TextStyle(
                        color: Color.fromRGBO(36, 38, 94, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [
                        0.3,
                        1
                      ],
                      colors: [
                        Color.fromRGBO(230, 50, 50, 1),
                        Color.fromRGBO(210, 107, 191, 1)
                      ]).createShader(bounds),
                  child: Text(
                    '${_datastoreHealthDataList!.length}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      // foreground: Paint()
                      //   ..shader = ui.Gradient.linear(
                      //       const Offset(0, 10), const Offset(250, 0), <Color>[
                      //     Color.fromRGBO(230, 50, 50, 1),
                      //     Color.fromRGBO(210, 107, 191, 1)
                      //   ]),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  // alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 15),
                  padding: EdgeInsets.all(10),
                  height: 130,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: const Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ]),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Steps',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(36, 38, 94, 1),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.3,
                              1
                            ],
                            colors: [
                              Color.fromRGBO(230, 50, 50, 1),
                              Color.fromRGBO(210, 107, 191, 1)
                            ]).createShader(bounds),
                        child: Text(
                          dailySteps == null ? '0' : '$dailySteps',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            // shadows: [
                            //   Shadow(
                            //       blurRadius: 50,
                            //       color: Colors.black54,
                            //       offset: Offset(0, 20))
                            // ],
                            // foreground: Paint()
                            //   ..shader = ui.Gradient.linear(const Offset(20, -20),
                            //       const Offset(200, 20), <Color>[
                            //     Color.fromRGBO(230, 50, 50, 1),
                            //     Color.fromRGBO(210, 107, 191, 1)
                            //   ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: EdgeInsets.all(10),
                  height: 130,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: const Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Heart Rate',
                            style: TextStyle(
                              color: Color.fromRGBO(36, 38, 94, 1),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.3,
                              1
                            ],
                            colors: [
                              Color.fromRGBO(230, 50, 50, 1),
                              Color.fromRGBO(210, 107, 191, 1)
                            ]).createShader(bounds),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              latestHeartRatePoint != 0
                                  ? "${latestHeartRatePoint!.round()}"
                                  : "0",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                // foreground: Paint()
                                //   ..shader = ui.Gradient.linear(
                                //       const Offset(20, -20),
                                //       const Offset(200, 20), <Color>[
                                //     Color.fromRGBO(230, 50, 50, 1),
                                //     Color.fromRGBO(210, 107, 191, 1)
                                //   ]),
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'bpm',
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    // foreground: Paint()
                                    //   ..shader = ui.Gradient.linear(
                                    //       const Offset(150, -20),
                                    //       const Offset(400, 20), <Color>[
                                    //     Color.fromRGBO(230, 50, 50, 1),
                                    //     Color.fromRGBO(210, 107, 191, 1)
                                    //   ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(10),
                  height: 130,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: const Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sleep',
                            style: TextStyle(
                              color: Color.fromRGBO(36, 38, 94, 1),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.bottomRight,
                                  stops: [
                                    0.3,
                                    1
                                  ],
                                  colors: [
                                    Color.fromRGBO(230, 50, 50, 1),
                                    Color.fromRGBO(210, 107, 191, 1)
                                  ]).createShader(bounds),
                              child: Text(
                                'Asleep',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // foreground: Paint()
                                  //   ..shader = ui.Gradient.linear(
                                  //       const Offset(150, -20),
                                  //       const Offset(400, 20), <Color>[
                                  //     Color.fromRGBO(230, 50, 50, 1),
                                  //     Color.fromRGBO(210, 107, 191, 1)
                                  //   ]),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Expanded(
                            child: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.bottomRight,
                                  stops: [
                                    0.3,
                                    1
                                  ],
                                  colors: [
                                    Color.fromRGBO(230, 50, 50, 1),
                                    Color.fromRGBO(210, 107, 191, 1)
                                  ]).createShader(bounds),
                              child: Text(
                                'In Bed',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // foreground: Paint()
                                  //   ..shader = ui.Gradient.linear(
                                  //       const Offset(150, -20),
                                  //       const Offset(400, 20), <Color>[
                                  //     Color.fromRGBO(230, 50, 50, 1),
                                  //     Color.fromRGBO(210, 107, 191, 1)
                                  //   ]),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox())
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.0,
                              0.5,
                              0.5,
                              1
                            ],
                            colors: [
                              // Color.fromRGBO(230, 50, 50, 1),
                              Color.fromRGBO(230, 50, 50, 1),
                              Color.fromRGBO(210, 107, 191, 1),
                              Color.fromRGBO(230, 50, 50, 1),
                              Color.fromRGBO(210, 107, 191, 1),
                              // Color.fromRGBO(210, 107, 191, 1)
                            ]).createShader(bounds),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${(dailySleepDuration! ~/ 60).round()}',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                // foreground: Paint()
                                //   ..shader = ui.Gradient.linear(
                                //       const Offset(150, -20),
                                //       const Offset(400, 20), <Color>[
                                //     Color.fromRGBO(230, 50, 50, 1),
                                //     Color.fromRGBO(210, 107, 191, 1)
                                //   ]),
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'hrs',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    // foreground: Paint()
                                    //   ..shader = ui.Gradient.linear(
                                    //       const Offset(150, -20),
                                    //       const Offset(400, 20), <Color>[
                                    //     Color.fromRGBO(230, 50, 50, 1),
                                    //     Color.fromRGBO(210, 107, 191, 1)
                                    //   ]),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${(dailySleepDuration! % 60).round()}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                // foreground: Paint()
                                //   ..shader = ui.Gradient.linear(
                                //       const Offset(150, -20),
                                //       const Offset(400, 20), <Color>[
                                //     Color.fromRGBO(230, 50, 50, 1),
                                //     Color.fromRGBO(210, 107, 191, 1)
                                //   ]),
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'min',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    // foreground: Paint()
                                    //   ..shader = ui.Gradient.linear(
                                    //       const Offset(150, -20),
                                    //       const Offset(400, 20), <Color>[
                                    //     Color.fromRGBO(230, 50, 50, 1),
                                    //     Color.fromRGBO(210, 107, 191, 1)
                                    //   ]),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Text(
                              '${(dailyInBedDuration! ~/ 60).round()}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                // foreground: Paint()
                                //   ..shader = ui.Gradient.linear(
                                //       const Offset(150, -20),
                                //       const Offset(400, 20), <Color>[
                                //     Color.fromRGBO(230, 50, 50, 1),
                                //     Color.fromRGBO(210, 107, 191, 1)
                                //   ]),
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'hrs',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    // foreground: Paint()
                                    //   ..shader = ui.Gradient.linear(
                                    //       const Offset(150, -20),
                                    //       const Offset(400, 20), <Color>[
                                    //     Color.fromRGBO(230, 50, 50, 1),
                                    //     Color.fromRGBO(210, 107, 191, 1)
                                    //   ]),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${(dailyInBedDuration! % 60).round()}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                // foreground: Paint()
                                //   ..shader = ui.Gradient.linear(
                                //       const Offset(150, -20),
                                //       const Offset(400, 20), <Color>[
                                //     Color.fromRGBO(230, 50, 50, 1),
                                //     Color.fromRGBO(210, 107, 191, 1)
                                //   ]),
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'min',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    // foreground: Paint()
                                    //   ..shader = ui.Gradient.linear(
                                    //       const Offset(150, -20),
                                    //       const Offset(400, 20), <Color>[
                                    //     Color.fromRGBO(230, 50, 50, 1),
                                    //     Color.fromRGBO(210, 107, 191, 1)
                                    //   ]),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (Platform.isIOS) ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    padding: EdgeInsets.all(10),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: const Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ]),
                    child: Column(
                      children: [
                        Text(
                          'Heart Rate Variability',
                          style: TextStyle(
                            color: Color.fromRGBO(36, 38, 94, 1),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.3,
                                1
                              ],
                              colors: [
                                Color.fromRGBO(230, 50, 50, 1),
                                Color.fromRGBO(210, 107, 191, 1)
                              ]).createShader(bounds),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${avgDailyHRVariability!.round()}',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  // foreground: Paint()
                                  //   ..shader = ui.Gradient.linear(
                                  //       const Offset(150, -20),
                                  //       const Offset(400, 20), <Color>[
                                  //     Color.fromRGBO(230, 50, 50, 1),
                                  //     Color.fromRGBO(210, 107, 191, 1)
                                  //   ]),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'ms',
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // foreground: Paint()
                                      //   ..shader = ui.Gradient.linear(
                                      //       const Offset(150, -20),
                                      //       const Offset(400, 20), <Color>[
                                      //     Color.fromRGBO(230, 50, 50, 1),
                                      //     Color.fromRGBO(210, 107, 191, 1)
                                      //   ]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding: EdgeInsets.all(10),
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: const Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ]),
                    child: Column(
                      children: [
                        Text(
                          'Resting Heart Rate',
                          style: TextStyle(
                            color: Color.fromRGBO(36, 38, 94, 1),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.3,
                                1
                              ],
                              colors: [
                                Color.fromRGBO(230, 50, 50, 1),
                                Color.fromRGBO(210, 107, 191, 1)
                              ]).createShader(bounds),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${avgDailyRestingHR!.round()}',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  // foreground: Paint()
                                  //   ..shader = ui.Gradient.linear(
                                  //       const Offset(150, -20),
                                  //       const Offset(400, 20), <Color>[
                                  //     Color.fromRGBO(230, 50, 50, 1),
                                  //     Color.fromRGBO(210, 107, 191, 1)
                                  //   ]),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'bpm',
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // foreground: Paint()
                                      //   ..shader = ui.Gradient.linear(
                                      //       const Offset(150, -20),
                                      //       const Offset(400, 20), <Color>[
                                      //     Color.fromRGBO(230, 50, 50, 1),
                                      //     Color.fromRGBO(210, 107, 191, 1)
                                      //   ]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox.shrink()
          ]

          //   aspectRatio: 1.7,
          //   child: Card(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(6)),
          //       elevation: 10,
          //       margin: EdgeInsets.symmetric(horizontal: 20),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           children: <Widget>[
          //             Row(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisSize: MainAxisSize.min,
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 const Text(
          //                   'Sleep',
          //                   style:
          //                       TextStyle(color: Colors.indigo, fontSize: 22),
          //                 )
          //               ],
          //             ),
          //             const SizedBox(
          //               height: 10,
          //             ),
          //             Expanded(child: BarChartWidget()),
          //           ],
          //         ),
          //       )),

          // ),
        ],
        physics: const AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: () {
        // fetchDailySteps();
        // fetchDailySleep();
        // fetchDailyHeartRate();
        // fetchDailyRestingHeartRate();
        return fetchData();
      },
    );
  }

  // Widget _contentDataReady() {
  //   return RefreshIndicator(
  //       child: ListView.builder(
  //         itemCount: _datastoreHealthDataList!.length,
  //         // itemCount: _healthDataList.length,
  //         itemBuilder: (_, index) {
  //           // HealthDataPoint p = _healthDataList[index];
  //           HealthDataPt p = _datastoreHealthDataList![
  //               index]; //Print Data from Local Datastore
  //           return ListTile(
  //             title: Text("${p.typeString}: ${p.value}"),
  //             trailing: Text('${p.unitString}'),
  //             subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
  //           );
  //         },
  //         physics: const AlwaysScrollableScrollPhysics(),
  //       ),
  //       onRefresh: () {
  //         return fetchData();
  //       });
  // }

  Widget _contentNoData() {
    List<String> noDataText = ["No Data to show, pull down to refresh."];
    return RefreshIndicator(
        child: ListView.builder(
            itemCount: noDataText.length,
            itemBuilder: (_, index) {
              return Text(
                noDataText[index],
                textScaleFactor: 1.3,
              );
            }),
        onRefresh: () {
          return fetchData();
        });
  }

  Widget _contentNotFetched() {
    return Text('something went wrong, please restart the app');
  }

  Widget _noAppState() {
    return Container();
  }

  Widget _authorizationNotGranted() {
    return RefreshIndicator(
      child: Text(
        '''Authorization not given. Refresh to try again.''',
        textAlign: TextAlign.center,
      ),
      onRefresh: () => fetchData(),
    );
  }

  Widget _userOptedOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
        ),
        Icon(
          CupertinoIcons.exclamationmark_circle,
          size: 100,
          color: Colors.red,
        ),
        const SizedBox(
          height: 80,
        ),
        Container(
          padding: EdgeInsets.all(20),
          // alignment: Alignment.bottomCenter,
          // width: 350,
          // height: MediaQuery.of(context).size.height,
          child: Text(
            "User has opted out of the study.\n"
            "No more data is being collected from the user.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        // Container(
        //   padding: EdgeInsets.all(20),
        //   // alignment: Alignment.bottomCenter,
        //   // width: 350,
        //   // height: MediaQuery.of(context).size.height,
        //   child: Text(
        //     "To opt back into the study\n"
        //     "Go to the menu in the top left corner",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontSize: 22,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.USER_OPTED_OUT)
      return _userOptedOut();
    else if (_state == AppState.DATA_NOT_FETCHED) return _contentNotFetched();
    return _noAppState();
  }

  Widget _navigationDrawer() {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(36, 38, 94, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Container(
              color: Colors.white,
              height: 240,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(59, 126, 245, 1),
                          Color.fromRGBO(106, 195, 163, 1),
                        ]).createShader(bounds),
                    child: Icon(
                      Icons.person_pin,
                      size: 105,
                      color: Color.fromRGBO(36, 38, 94, 1),
                    ),
                  ),
                  Text(
                    'Anonymous',
                    style: TextStyle(fontSize: 28, color: Colors.black87),
                  ),
                  Text(
                    'User',
                    style: TextStyle(fontSize: 28, color: Colors.black87),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // if (_state == AppState.USER_OPTED_OUT) ...[
            //   SizedBox.shrink()
            // ] else ...[

// buildMenuItem(
//                       text: 'Disable Notifications',
//                       icon: Icons.notifications_off,
//                       onClicked: () {
//                         try {
//                           NotificationApi.cancelAll();
//                           // saveNotificationsFlag(false);
//                           // setState(() => notificationsFlag = false);
//                           print('All notifications disabled');
//                         } catch (error) {
//                           print(error);
//                         }
//                       })

            // if (notificationsFlag == null) ...[
            //   SizedBox.shrink()
            // ] else if (notificationsFlag == true) ...[
            //   buildMenuItem(
            //       text: 'Disable Notifications',
            //       icon: Icons.notifications_off,
            //       onClicked: () {
            //         try {
            //           NotificationApi.cancelAll();
            //           saveNotificationsFlag(false);
            //           setState(() => notificationsFlag = false);
            //           print('All notifications disabled');
            //         } catch (error) {
            //           print(error);
            //         }
            //       })
            // ] else if (notificationsFlag == false) ...[
            //   buildMenuItem(
            //       text: 'Enable Notifications',
            //       icon: Icons.notifications_on,
            //       onClicked: () {
            //         try {
            //           NotificationApi.showScheduledNotification(
            //               scheduledDate: DateTime.now());
            //           print('Notifications scheduled');
            //           saveNotificationsFlag(true);
            //           setState(() => notificationsFlag = true);
            //         } catch (error) {
            //           print(error);
            //         }
            //       })
            // ],
            // const SizedBox(
            //   height: 10,
            // ),
            // ],

            /// Update Demographic Data Button
            buildMenuItem(
                text: 'Update my info',
                icon: Icons.upgrade,
                onClicked: () {
                  Navigator.pushReplacementNamed(context, '/validation_form');
                  // updateDemographicData();
                  // Navigator.pop(context);
                }),

            const SizedBox(
              height: 10,
            ),

            _state == AppState.USER_OPTED_OUT
                ? buildMenuItem(
                    text: 'Opt In',
                    icon: Icons.input,
                    onClicked: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                              'Do you want to enter back into the study and resume sharing your data?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, 'No'),
                                child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  optOut(false);
                                  fetchData();
                                  scheduleNotifications();
                                  Navigator.pushNamed(context, '/dashboard');
                                },
                                child: const Text('Yes'))
                          ],
                        ),
                        barrierDismissible: false,
                      );
                      // optOut(false);
                      // fetchData();
                      // Navigator.pushNamed(context, '/dashboard');
                    })
                : buildMenuItem(
                    text: 'Opt Out',
                    icon: Icons.error_outline_rounded,
                    onClicked: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Are you sure you want to Opt-Out?'),
                          content: Text(
                              'Do you want to opt out of the study and stop sharing your data?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, 'No'),
                                child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  optOut(true);
                                  // fetchData();
                                  NotificationApi.cancelAll();
                                  Navigator.pushNamed(context, '/dashboard');
                                },
                                child: const Text('Yes'))
                          ],
                        ),
                        barrierDismissible: false,
                      );
                    }),

            // const SizedBox(
            //   height: 10,
            // ),

            ///Settings Button
            // buildMenuItem(
            //     text: 'Settings',
            //     icon: Icons.settings,
            //     onClicked: () {
            //       Navigator.pushReplacementNamed(context, '/settings_screen');
            //     }),

            Divider(color: Colors.white),

            const SizedBox(
              height: 10,
            ),

            buildMenuItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () {
                  clearLogin();
                  Amplify.Auth.signOut().then(
                      (_) => Navigator.pushReplacementNamed(context, '/'));
                }),

            // const SizedBox(
            //   height: 10,
            // ),

            ///Erase datastore button
            // buildMenuItem(
            //     text: 'Erase Datastore',
            //     icon: Icons.delete_forever,
            //     onClicked: () {
            //       resetLastRefreshed1();
            //       deleteDatastore(currentHealthDataUser!);
            //       _datastoreHealthDataList!.clear();
            //       setState(() => _state = AppState.NO_DATA);
            //     }),

            // const SizedBox(
            //   height: 10,
            // ),
            // buildMenuItem(
            //     text: 'Clear Datastore',
            //     icon: Icons.delete_forever,
            //     onClicked: () {
            //       // resetLastRefreshed1();
            //       // deleteDatastore(currentHealthDataUser!);
            //       // _datastoreHealthDataList!.clear();
            //       // setState(() => _state = AppState.NO_DATA);
            //       clearDatastore();
            //     }),
            // Expanded(child: Container()),
            // SizedBox(height: 300),
            const Spacer(),
            TermsOfUse(),
            // ListTile(title: Text("footer"), onTap: () => print('hi')),
            // const Spacer()
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      onTap: onClicked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: _navigationDrawer(),
        appBar: AppBar(
          title: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.0,
                  0.8
                ],
                colors: [
                  Color.fromRGBO(59, 126, 245, 0.9),
                  Color.fromRGBO(106, 195, 163, 1),
                ]).createShader(bounds),
            child: Text(
              'Dashboard',
              style: TextStyle(
                // color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                // foreground: Paint()
                //   ..shader = ui.Gradient.linear(
                //       const Offset(150, 10), const Offset(300, -10), <Color>[
                //     Color.fromRGBO(106, 195, 163, 1),
                //     Color.fromRGBO(59, 126, 245, 1),
                //   ]),
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(36, 38, 94, 1),
          actions: <Widget>[],
        ),
        body: Center(
          child: _content(),
        ),
        floatingActionButton: _state == AppState.USER_OPTED_OUT
            ? null
            : SpeedDial(
                icon: Icons.add,
                activeIcon: Icons.close,
                label: Text(
                  'Log Data',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                // elevation: 100,
                buttonSize: const Size(50, 50),
                childrenButtonSize: const Size(60, 60),
                backgroundColor: Color.fromRGBO(36, 38, 94, 1),
                overlayOpacity: 0.6,
                // childPadding: EdgeInsets.all(0),
                overlayColor: Colors.black,
                spacing: 12,
                spaceBetweenChildren: 12,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.sick),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(36, 38, 94, 1),
                    label: 'Illness',
                    labelStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    onTap: () {
                      int nextScreenState = 2;
                      Navigator.of(context).pushReplacementNamed('/symptom_log',
                          arguments: nextScreenState);
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.post_add_outlined),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(36, 38, 94, 1),
                    label: 'Symptoms',
                    labelStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    onTap: () {
                      int nextScreenState = 1;
                      Navigator.of(context).pushReplacementNamed('/symptom_log',
                          arguments: nextScreenState);
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.local_drink),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(36, 38, 94, 1),
                    label: 'Alcohol Consumption',
                    labelStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    onTap: () {
                      int nextScreenState = 0;
                      Navigator.of(context).pushReplacementNamed('/symptom_log',
                          arguments: nextScreenState);
                    },
                  ),
                ],
              ),
        // FloatingActionButton.extended(
        //     label: const Text('Log Data'),
        //     backgroundColor: Color.fromRGBO(50, 75, 205, 1),
        //     onPressed: () {
        //       // setState(() => _state = AppState.LOGGING_SYMPTOMS);
        //       Navigator.pushReplacementNamed(context, '/symptom_log');
        //     },
        //     icon: const Icon((Icons.add), color: Colors.white),
        //   )
      ),
    );
  }
  //
}
