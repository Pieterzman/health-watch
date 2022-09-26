import 'dart:async';
import 'dart:io' show File, Platform;
// import 'dart:ui' as ui;
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:csv/csv.dart';
import 'package:dart_ipify/dart_ipify.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health/health.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

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
  USER_OPTED_OUT
}

class _DashboardScreenState extends State<DashboardScreen> {
  AuthUser? _user;
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> _healthDataList = [];
  // List<HealthDataPt>? _datastoreHealthDataList = [];
  HealthDataUser? currentHealthDataUser;
  int? totalHealthDatapointsLogged;
  bool? optedOut;
  bool? networkFlag;
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

  ///last datapoint that was
  String? lastBatchSyncDate;
  bool uploadingToStorage = false;

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
        // fetchDashboardData();
        fetchBatchData();
        // fetchData();
      });
    }).catchError((error) {
      print((error as AuthException).message);
    });

    // NotificationApi.showScheduledNotification(scheduledDate: DateTime.now());
    // print('Notifications scheduled');
    // notificationsFlag = true;
  }

  // Future<void> tzsetup() async {
  //   try {
  //     tz.initializeTimeZones();
  //     final locationName = await FlutterNativeTimezone.getLocalTimezone();
  //     tz.setLocalLocation(tz.getLocation(locationName));
  //     NotificationApi.init(initScheduled: true);
  //   } catch (e) {
  //     print("failed to setup timezone");
  //   }
  // }

  void scheduleNotifications() async {
    NotificationApi.showScheduledNotification(
        title: 'Hey User',
        body: 'Please remember to log your most recent data.',
        // scheduledDate: now.add(Duration(days: 0, seconds: 10))
        scheduledDate: DateTime.now());

    print('Notifications scheduled');
    // NotificationApi.cancelAll();
    // NotificationApi.showScheduledNotification(
    //     title: 'Hey User',
    //     body: 'Please remember to log your most recent data.',
    //     scheduledDate: DateTime.now());
    // print('Notifications scheduled');
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

  // Future fetchData() async {
  //   HealthDataUser? currentuser = await getCurrentHealthDataUser();
  //   // writeWifiData(currentuser!);
  //   // currentuser = currentHealthDataUser;
  //   // final Future<String?> useruuid = getUserUUID();
  //   final prefs = await SharedPreferences.getInstance();
  //   final useruuid = prefs.getString("useruuid");
  //   final lastrefreshed = prefs.getString("lastrefreshed");
  //   // String? lastDayS = prefs.getString("lastDaySynced");
  //   // bool demographicDataLogged = prefs.getBool("demographicDataLogged")!;
  //   // DateTime lastDaySynched = DateTime.parse(lastDayS!);
  //   DateTime lastRefreshed1 = DateTime.parse(lastrefreshed!);
  //   DateTime? lastRefreshed2 = await getLastRefreshed2(useruuid!);
  //   optedOut = prefs.getBool('opt_out');
  //   DateTime now = DateTime.now();
  //   // DateTime startOfDay = DateTime(now.year, now.month, now.day);
  //   // DateTime endOfDay = startOfDay.add(Duration(days: 1));

  //   if (lastRefreshed2 != lastRefreshed1) {
  //     print("last refreshed times not the same");
  //   }

  //   // Stream<SubscriptionEvent<HealthDataPt>> stream =
  //   //     Amplify.DataStore.observe(HealthDataPt.classType);

  //   // stream.listen((event) {
  //   //   print('Received event of type ' + event.eventType.toString());
  //   //   print('Received HealthDataPt ' + event.item.toString());
  //   // });

  //   DateTime startDate = lastRefreshed1;
  //   DateTime endDate = DateTime.now().toUtc();
  //   // DateTime endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 999);
  //   print("startDate: $startDate --- endDate: $endDate");

  //   ////////////////////////////////////     Get Each Day in between lastsynced and yesterday midnight
  //   // var midnight = DateTime(startDate.year, startDate.month, startDate.day);
  //   // var nextMidnight = DateTime(
  //   //     midnight.year, midnight.month, midnight.day + 1, 23, 59, 59, 999);
  //   // var endMidnight = DateTime(endDate.year, endDate.month, endDate.day);

  //   // if (startDate.day != endDate.day) {
  //   //   do {
  //   //     print('$midnight---$nextMidnight');
  //   //     midnight = nextMidnight;
  //   //     nextMidnight =
  //   //         DateTime(midnight.year, midnight.month, midnight.day + 1);
  //   //   } while (nextMidnight.isBefore(endMidnight));
  //   // }
  //   ////////////////////////////////////

  //   // HealthFactory health = HealthFactory();

  //   List<HealthDataType>? types;
  //   List<HealthDataAccess>? permissions;

  //   /// Define the types to get.
  //   if (Platform.isAndroid) {
  //     types = [
  //       HealthDataType.STEPS,
  //       HealthDataType.HEART_RATE,
  //       HealthDataType.SLEEP_IN_BED,
  //       HealthDataType.SLEEP_ASLEEP
  //     ];
  //     permissions = [
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //     ];
  //   } else if (Platform.isIOS) {
  //     types = [
  //       HealthDataType.STEPS,
  //       HealthDataType.HEART_RATE,
  //       HealthDataType.RESTING_HEART_RATE,
  //       HealthDataType.HEART_RATE_VARIABILITY_SDNN,
  //       HealthDataType.SLEEP_IN_BED,
  //       HealthDataType.SLEEP_ASLEEP
  //     ];
  //     permissions = [
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //       HealthDataAccess.READ,
  //     ];
  //   }

  //   setState(() => _state = AppState.FETCHING_DATA);

  //   /// You MUST request access to the data types before reading them
  //   if (Platform.isAndroid) {
  //     final permissionStatus = await Permission.activityRecognition.request();
  //     if (await permissionStatus.isDenied ||
  //         await permissionStatus.isPermanentlyDenied) {
  //       setState(() {
  //         AppState.AUTH_NOT_GRANTED;
  //       });
  //     }
  //   }

  //   bool accessWasGranted =
  //       await health.requestAuthorization(types!, permissions: permissions!);

  //   print(accessWasGranted);

  //   // if (currentuser!.opt_out == false) {
  //   if (accessWasGranted && optedOut == false) {
  //     try {
  //       /// Fetch new data
  //       List<HealthDataPoint> healthData =
  //           await health.getHealthDataFromTypes(startDate, endDate, types);

  //       /// Save all the new data points //////////////////////////////////////////////////////////////////   OPTIMIZE
  //       _healthDataList.addAll(healthData);
  //     } catch (e) {
  //       print("Caught exception in getHealthDataFromTypes: $e");
  //     }

  //     if (_healthDataList.isNotEmpty) {
  //       /// Filter out duplicates

  //       _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

  //       ///Sort and Find most recent datapoint
  //       _healthDataList.sort((a, b) => a.dateTo.compareTo(b.dateTo));

  //       /// Find and save last refreshed
  //       HealthDataPoint lastHealthDataPoint = _healthDataList.last;
  //       DateTime lastHealthDataPointDate = lastHealthDataPoint.dateTo.toUtc();
  //       lastHealthDataPointDate =
  //           lastHealthDataPointDate.add(const Duration(milliseconds: 1));

  //       prefs.setString(
  //           'lastrefreshed', lastHealthDataPointDate.toIso8601String());

  //       updateLastRefreshed2(TemporalDateTime(lastHealthDataPointDate));

  //       /// Save Data to DataStore

  //       _healthDataList.forEach((x) async {
  //         TemporalDateTime temporalDateTimeFrom = TemporalDateTime(x.dateFrom);
  //         TemporalDateTime temporalDateTimeTo = TemporalDateTime(x.dateTo);
  //         writeDatastore(
  //             currentuser,
  //             x.typeString,
  //             x.value.toDouble(),
  //             x.unitString,
  //             x.sourceId,
  //             temporalDateTimeFrom,
  //             temporalDateTimeTo);
  //       });
  //     }

  //     /// Get HealthData from DataStore
  //     _datastoreHealthDataList = await readDatastore(currentuser);

  //     // updateLastRefreshed2(TemporalDateTime(lastHealthDataPt));
  //     _healthDataList.clear();

  //     /// Update the UI to display the results
  //     setState(() {
  //       _state = _datastoreHealthDataList!.isEmpty
  //           ? AppState.NO_DATA
  //           : AppState.DATA_READY;
  //     });

  //     ///
  //   } else if (!accessWasGranted && optedOut == false) {
  //     print("Authorization not granted");
  //     setState(() => _state = AppState.AUTH_NOT_GRANTED);
  //   } else if (optedOut == true) {
  //     setState(() => _state = AppState.USER_OPTED_OUT);
  //   }
  //   // } else {
  //   //   print("User Opted out of the study");
  //   //   setState(() => _state = AppState.DATA_NOT_FETCHED);
  //   // }
  // }

  Future<void> fetchDashboardData() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));
    _state = AppState.FETCHING_DATA;

    ///check for access

    dailySteps = await health.getTotalStepsInInterval(startOfDay, endOfDay);
    await fetchDailySleep(now);
    await fetchDailyHeartRate(startOfDay, endOfDay);

    if (Platform.isIOS) {
      await fetchDailyRestingHeartRate(startOfDay, endOfDay);
      await fetchDailyHeartRateVariability(startOfDay, endOfDay);
    }

    setState(() {
      _state = AppState.DATA_READY;
    });
    // _state = AppState.DATA_READY;
  }

  Future<void> fetchBatchData() async {
    HealthDataUser? currentuser = await getCurrentHealthDataUser();
    await writeWifiData(currentuser!);
    HealthFactory health = HealthFactory();
    final prefs = await SharedPreferences.getInstance();
    final lastrefreshed3 = prefs.getString("lastrefreshed3");
    DateTime lastRefreshedBatch = DateTime.parse(lastrefreshed3!);
    // DateTime lastRefreshedBatch = DateTime(2022, 5, 9);
    optedOut = prefs.getBool('opt_out')!;
    setState(() => _state = AppState.FETCHING_DATA);
    DateTime? lastBatchDataPointDate;
    totalHealthDatapointsLogged = prefs.getInt("totalHealthDataPoints");

    /// Declare DateTimes
    DateTime now = DateTime.now();
    DateTime startBatchDate = lastRefreshedBatch;
    // DateTime endDate = DateTime.now().toUtc();
    // DateTime endBatchDate = DateTime(now.year, now.month, now.day);
    // print("startBatchDate: $startBatchDate --> endBatchDate: $endBatchDate");

    ///Declare Lists
    List<HealthDataPoint> _batchHealthDataList = [];
    List<HealthDataType>? types;

    /// Define the health types to get.
    if (Platform.isAndroid) {
      types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP
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
    }

    if (Platform.isAndroid) {
      final permissionStatus = await Permission.activityRecognition.request();
      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        // setState(() {
        //   AppState.AUTH_NOT_GRANTED;
        // });
      }
    }

    bool accessWasGranted = await health.requestAuthorization(types!);

    if (accessWasGranted && optedOut == false) {
      //////////Get last datapoint date
      List<HealthDataPoint> lastBatchHealthData =
          await health.getHealthDataFromTypes(
              DateTime(now.year, now.month, now.day - 5),
              DateTime.now(),
              types);

      lastBatchHealthData.sort((a, b) => a.dateTo.compareTo(b.dateTo));
      lastBatchDataPointDate = lastBatchHealthData.last.dateTo;
      print(
          "startBatchDate: $startBatchDate --> endBatchDate: $lastBatchDataPointDate");
      //////////

      ////////////////////////////////////     Get Each Day in between lastsynced and yesterday midnight
      var midnight = startBatchDate;
      // DateTime(startBatchDate.year, startBatchDate.month, startBatchDate.day);
      var nextMidnight =
          DateTime(midnight.year, midnight.month, midnight.day + 1);
      var endMidnight = DateTime(lastBatchDataPointDate.year,
          lastBatchDataPointDate.month, lastBatchDataPointDate.day);

      bool batchIsEmpty = false;

      if ((nextMidnight.isBefore(endMidnight) ||
              nextMidnight.isAtSameMomentAs(endMidnight)) &&
          networkFlag == true) {
        do {
          print('$midnight---$nextMidnight');
///////////////////////////////
          try {
            List<HealthDataPoint> batchHealthData = await health
                .getHealthDataFromTypes(midnight, nextMidnight, types);

            _batchHealthDataList.addAll(batchHealthData);
          } catch (e) {
            print("Caught exception in getHealthDataFromTypes: $e");
          }

          if (_batchHealthDataList.isNotEmpty) {
            /// Filter out duplicates
            _batchHealthDataList =
                HealthFactory.removeDuplicates(_batchHealthDataList);

            ///Sort and Find most recent datapoint
            _batchHealthDataList.sort((a, b) => a.dateTo.compareTo(b.dateTo));
            // lastBatchDataPointDate = _batchHealthDataList.last.dateTo;

            generateCsvFile(
                _batchHealthDataList, currentuser, midnight, nextMidnight);

            totalHealthDatapointsLogged =
                totalHealthDatapointsLogged! + _batchHealthDataList.length;

            prefs.setInt("totalHealthDataPoints", totalHealthDatapointsLogged!);

            ///
            ///
            ///

          } else {
            print("Batch HealthDataList is Empty");
            // prefs.setString(
            //     'lastrefreshed3',
            //     DateTime(midnight.year, midnight.month, midnight.day - 1)
            //         .toIso8601String());

            // batchIsEmpty = true;
          }
          prefs.setString('lastrefreshed3', nextMidnight.toIso8601String());
          updateLastRefreshed2(TemporalDateTime(nextMidnight));
          midnight = nextMidnight;
          nextMidnight =
              DateTime(midnight.year, midnight.month, midnight.day + 1);

          //////////////////////////////

          _batchHealthDataList = [];
        } while ((nextMidnight.isBefore(endMidnight) ||
                nextMidnight.isAtSameMomentAs(endMidnight)) &&
            batchIsEmpty == false);
        print("StartDay is the same as EndDay");
      } else if (networkFlag == false) {
        print("could not fetch health data to upload, because network is down");
      }

      lastBatchSyncDate = prefs
          .getString(
            "lastrefreshed3",
          )!
          .substring(0, 10);

      await fetchDashboardData();
      setState(() => _state = AppState.DATA_READY);
      ////////////////////////////////////
    } else if (!accessWasGranted && optedOut == false) {
      print("Authorization not granted");
      setState(() => _state = AppState.AUTH_NOT_GRANTED);
    } else if (optedOut == true) {
      setState(() => _state = AppState.USER_OPTED_OUT);
    }
  }

  Future<void> generateCsvFile(
      List<HealthDataPoint> batchHealthDataList,
      HealthDataUser currentuser,
      DateTime startMidnightDate,
      DateTime endMidnightDate) async {
    // setState(() => _state = AppState.GENERATING_CSV);
    List<List<dynamic>> userListOfHealthData = [];

    userListOfHealthData = List<List<dynamic>>.empty(growable: true);

    List<dynamic> headerRow = [];
    headerRow.add("UserID");
    headerRow.add("typeString");
    headerRow.add("value");
    headerRow.add("unitString");
    headerRow.add("sourceID");
    headerRow.add("dateFrom");
    headerRow.add("dateTo");
    userListOfHealthData.add(headerRow);

    batchHealthDataList.forEach((Pt) {
      List<dynamic> row = List.empty(growable: true);
      row.add("${currentuser.id}");
      row.add("${Pt.typeString}");
      row.add("${Pt.value}");
      row.add("${Pt.unitString}");
      row.add("${Pt.sourceId}");
      row.add("${TemporalDateTime(Pt.dateFrom)}");
      row.add("${TemporalDateTime(Pt.dateTo)}");
      // print(row);
      userListOfHealthData.add(row);
      // print(userListOfHealthData);
    });

    String csv = const ListToCsvConverter().convert(userListOfHealthData);
    print(csv);
    uploadCSVFileToS3(csv, currentuser, startMidnightDate, endMidnightDate);
  }

  Future<void> uploadCSVFileToS3(String csv, HealthDataUser currentuser,
      DateTime startDate, DateTime endDate) async {
    // setState(() => _state = AppState.UPLOADING_TO_S3);

// Create a dummy file
    // final csvString = 'Example file contents';
    final tempDir = await getTemporaryDirectory();
    final csvFile = File(tempDir.path + '/$startDate-$endDate' + '.csv')
      ..createSync()
      ..writeAsStringSync(csv);

    print(tempDir.path + '/$startDate-$endDate' + '.csv');

    final uploadOptions = S3UploadFileOptions(
      accessLevel: StorageAccessLevel.private,
    );

    // Upload the file to S3
    try {
      setState(() => uploadingToStorage = true);
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: csvFile,
          key:
              'daily/${currentuser.id}/${TemporalDateTime(startDate)}-${TemporalDateTime(endDate)}.csv',
          options: uploadOptions,
          onProgress: (progress) {
            print("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      print('Successfully uploaded file: ${result.key}');
      setState(() => uploadingToStorage = false);
      // setState(() => _state = AppState.DONE_UPLOADED);
      File(tempDir.path + '/$startDate-$endDate' + '.csv').delete();
      print("${tempDir.path + '/$startDate-$endDate' + '.csv'} ---> Deleted");
    } on StorageException catch (e) {
      print('Error uploading file: $e');
    }
  }

  // Future<void> findLastHealthDataPoint() {
  //   DateTime now = DateTime.now();
  //   DateTime midnightToday = DateTime(now.year, now.month, now.day);
  // }

//   Future<void> uploadCSVFileToS3() async {
// // Create a dummy file
//     final exampleString = 'Example file contents';
//     final tempDir = await getTemporaryDirectory();
//     final exampleFile = File(tempDir.path + '/example.txt')
//       ..createSync()
//       ..writeAsStringSync(exampleString);

//     // Upload the file to S3
//     try {
//       final UploadFileResult result = await Amplify.Storage.uploadFile(
//           local: exampleFile,
//           key: 'ExampleKey',
//           onProgress: (progress) {
//             print("Fraction completed: " +
//                 progress.getFractionCompleted().toString());
//           });
//       print('Successfully uploaded file: ${result.key}');
//     } on StorageException catch (e) {
//       print('Error uploading file: $e');
//     }
//   }

  Future<void> writeWifiData(HealthDataUser currentuser) async {
    try {
      DateTime now = DateTime.now();
      final ipv4 = await Ipify.ipv4(); //public wifi IP
      print(ipv4);

      setState(() => networkFlag = true);

      ///Save WifiIP to DataStore
      try {
        WifiPt newWifiPt = WifiPt(
            healthdatauserID: currentuser.id,
            loggedWifiIP: ipv4,
            loggedDate: TemporalDateTime(now));

        await Amplify.DataStore.save(newWifiPt);
        print("Created: $newWifiPt");
      } catch (e) {
        print("Caught exception in saving newWifiPt: $e");
      }
    } on Exception catch (e) {
      // throw e;
      setState(() => networkFlag = false);
      print(e);
    }
  }

  Future fetchDailySleep(DateTime now) async {
    DateTime endOfSleepDay = DateTime(now.year, now.month, now.day, 19);
    DateTime startOfSleepDay = DateTime(
        endOfSleepDay.year, endOfSleepDay.month, endOfSleepDay.day - 1, 19);
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
  // Future<void> writeDatastore(
  //     HealthDataUser? currentuser,
  //     String type,
  //     double val,
  //     String unit,
  //     String sourceid,
  //     TemporalDateTime datefrom,
  //     TemporalDateTime dateto) async {
  //   try {
  //     HealthDataPt newHealthDataPt = HealthDataPt(
  //         healthdatauserID: currentuser!.id,
  //         typeString: type,
  //         value: val,
  //         unitString: unit,
  //         sourceID: sourceid,
  //         dateFrom: datefrom,
  //         dateTo: dateto);
  //     await Amplify.DataStore.save(newHealthDataPt);
  //     // print("Saved: $newHealthDataPt");
  //   } catch (e) {
  //     print("Caught exception in getHealthDataFromTypes: $e");
  //   }
  // }

  ///Read Data from Local Datastore
  // Future<List<HealthDataPt>?> readDatastore(HealthDataUser? currentuser) async {
  //   try {
  //     List<HealthDataPt> healthdatapts = await Amplify.DataStore.query(
  //         HealthDataPt.classType,
  //         where: HealthDataPt.HEALTHDATAUSERID.eq(currentuser!.id),
  //         pagination: new QueryPagination(page: 0, limit: 10000),
  //         sortBy: [HealthDataPt.DATETO.descending()]);
  //     return healthdatapts;
  //   } on DataStoreException catch (e) {
  //     print("Query failed: $e");
  //     return null;
  //   }
  // }

  /// Delete Data from Local Datastore
  Future<void> deleteDatastore(HealthDataUser currentuser) async {
    // (await Amplify.DataStore.query(HealthDataPt.classType,
    //         pagination: new QueryPagination(page: 0, limit: 1000000),
    //         where: HealthDataPt.HEALTHDATAUSERID.eq(currentuser.id)))
    //     .forEach((element) async {
    //   try {
    //     await Amplify.DataStore.delete(element);
    //     // print("Deleted: $element");
    //   } on DataStoreException catch (e) {
    //     print("Delete Failed: $e");
    //   }
    // });

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

  Future<void> resetLastRefreshed3() async {
    DateTime now = DateTime.now();
    DateTime twoWeeksAgo = now.subtract(Duration(days: 14));
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'lastrefreshed3',
        DateTime(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day)
            .toIso8601String());
    prefs.setInt("totalHealthDataPoints", 0);
    totalHealthDatapointsLogged = 0;
    setState(() => print(now.subtract(Duration(days: 14))));
    ;
  }

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
                    '${totalHealthDatapointsLogged}',
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

        // return fetchDashboardData();
        return fetchBatchData();
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
    List<String> noDataText = [
      "No Data to show, pull down to refresh.",
      "",
      "Please make sure that your smartwatch data is syncing to Google Fit or Apple Health."
    ];
    return RefreshIndicator(
        child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: noDataText.length,
            itemBuilder: (_, index) {
              return Text(
                noDataText[index],
                textScaleFactor: 1.3,
                textAlign: TextAlign.center,
              );
            }),
        onRefresh: () {
          // return fetchDashboardData();
          return fetchBatchData();
        });
  }

  Widget _contentNotFetched() {
    // return Text('something went wrong, please restart the app');
    return Text('');
  }

  Widget _noAppState() {
    return Container();
  }

  Widget _authorizationNotGranted() {
    // return RefreshIndicator(
    //   child: Text(
    //     '''Authorization not given. Refresh to try again.''',
    //     textAlign: TextAlign.center,
    //   ),
    //   onRefresh: () => fetchData(),
    // );
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
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
            // buildMenuItem(
            //     text: 'Update my info',
            //     icon: Icons.upgrade,
            //     onClicked: () {
            //       Navigator.pushReplacementNamed(context, '/validation_form');
            //       // updateDemographicData();
            //       // Navigator.pop(context);
            //     }),

            Visibility(
              child: buildMenuItem(
                  text: 'Upload past health data',
                  icon: Icons.upload_file,
                  onClicked: () {
                    Navigator.pushReplacementNamed(context, '/upload_data');
                    // updateDemographicData();
                    // Navigator.pop(context);
                  }),
              visible:
                  (networkFlag == true && optedOut == false) ? true : false,
              // visible: true,
            ),
            Visibility(
              child: buildMenuItem(
                  text: 'Reset Last Refreshed3',
                  icon: Icons.functions,
                  onClicked: () {
                    resetLastRefreshed3();
                    // final prefs = SharedPreferences.getInstance();
                    // prefs.setString('lastrefreshed3', nextMidnight.toIso8601String());
                  }),
              visible: false,
            ),

            // const SizedBox(
            //   height: 10,
            // ),

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
                                  // fetchData();
                                  // fetchDashboardData();
                                  fetchBatchData();
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

            // const SizedBox(
            //   height: 10,
            // ),

            buildMenuItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () {
                  clearLogin();
                  Amplify.Auth.signOut().then(
                      (_) => Navigator.pushReplacementNamed(context, '/'));
                }),

            Divider(color: Colors.white),

            Visibility(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Last Synced Date: $lastBatchSyncDate",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              visible: optedOut == true ? false : true,
            ),

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
          actions: <Widget>[
            networkFlag == false
                ? Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.signal_wifi_statusbar_connected_no_internet_4,
                      size: 20,
                      color: Colors.red,
                    ),
                  )
                : uploadingToStorage == true
                    ? Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(Icons.cloud_upload_outlined),
                      )
                    : SizedBox.shrink()
          ],
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
                      Navigator.of(context).pushReplacementNamed('/log_data',
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
                      Navigator.of(context).pushReplacementNamed('/log_data',
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
                      Navigator.of(context).pushReplacementNamed('/log_data',
                          arguments: nextScreenState);
                    },
                  ),
                ],
              ),
      ),
    );
  }
  //
}
