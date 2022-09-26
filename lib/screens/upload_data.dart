import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadS3DataScreen extends StatefulWidget {
  const UploadS3DataScreen({Key? key}) : super(key: key);

  @override
  State<UploadS3DataScreen> createState() => _UploadS3DataScreenState();
}

enum AppState {
  SELECTING_DATES,
  GETTING_HEALTH_DATA,
  GENERATING_CSV,
  UPLOADING_TO_S3,
  DONE_UPLOADED
}

class _UploadS3DataScreenState extends State<UploadS3DataScreen> {
  AppState _state = AppState.SELECTING_DATES;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate = DateTime.now();

  Future<void> fetchBatchData(DateTime startDate, DateTime endDate) async {
    setState(() => _state = AppState.GETTING_HEALTH_DATA);

    HealthFactory health = HealthFactory();
    final prefs = await SharedPreferences.getInstance();
    bool optedOut = prefs.getBool('opt_out')!;
    List<HealthDataType>? types;
    List<HealthDataPoint> _batchHealthDataList = [];

    /// Define the types to get.
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
      try {
        /// Fetch Batch Data
        List<HealthDataPoint> batchHealthData =
            await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points //////////////////////////////////////////////////////////////////   OPTIMIZE
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

        generateCsvFile(_batchHealthDataList);
      } else
        print("Batch HealthDataList is Empty");
    } else
      print("Error fetching Batch Data");
  }

  Future<void> generateCsvFile(
      List<HealthDataPoint> batchHealthDataList) async {
    setState(() => _state = AppState.GENERATING_CSV);
    List<List<dynamic>> userListOfHealthData = [];

    userListOfHealthData = List<List<dynamic>>.empty(growable: true);

    List<dynamic> headerRow = [];
    headerRow.add("typeString");
    headerRow.add("value");
    headerRow.add("unitString");
    headerRow.add("sourceID");
    headerRow.add("dateFrom");
    headerRow.add("dateTo");
    userListOfHealthData.add(headerRow);

    batchHealthDataList.forEach((Pt) {
      List<dynamic> row = List.empty(growable: true);
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
    uploadCSVFileToS3(csv, _selectedStartDate!, _selectedEndDate!);
  }

  Future<void> uploadCSVFileToS3(
      String csv, DateTime startDate, DateTime endDate) async {
    setState(() => _state = AppState.UPLOADING_TO_S3);
// Create a dummy file
    // final csvString = 'Example file contents';
    final tempDir = await getTemporaryDirectory();
    final csvFile = File(tempDir.path +
        '/${startDate.toString().substring(0, 10)}-${endDate.toString().substring(0, 10)}' +
        '.csv')
      ..createSync()
      ..writeAsStringSync(csv);

    print(tempDir.path +
        '/${startDate.toString().substring(0, 10)}-${endDate.toString().substring(0, 10)}' +
        '.csv');

    final uploadOptions = S3UploadFileOptions(
      accessLevel: StorageAccessLevel.private,
    );

    // Upload the file to S3
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: csvFile,
          key:
              'batch/${TemporalDateTime(startDate)}-${TemporalDateTime(endDate)}.csv',
          options: uploadOptions,
          onProgress: (progress) {
            print("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      print('Successfully uploaded file: ${result.key}');
      setState(() => _state = AppState.DONE_UPLOADED);
      File(tempDir.path +
              '/${startDate.toString().substring(0, 10)}-${endDate.toString().substring(0, 10)}' +
              '.csv')
          .deleteSync();
    } on StorageException catch (e) {
      print('Error uploading file: $e');
    }
  }

  Widget _selectingDates() {
    return Scaffold(
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
              'Select Dates to Upload',
              style: TextStyle(
                // color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
        backgroundColor: Color.fromRGBO(36, 38, 94, 1),
        leading: MaterialButton(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(230, 50, 50, 1),
                              Color.fromRGBO(210, 107, 191, 1)
                            ]).createShader(bounds),
                        child: Icon(
                          CupertinoIcons.calendar,
                          size: 100,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          _selectedStartDate == null
                              ? "No date"
                              : "${_selectedStartDate!.year.toString()}/${_selectedStartDate!.month.toString().padLeft(2, '0')}/${_selectedStartDate!.day.toString().padLeft(2, '0')}",
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: Color.fromRGBO(36, 38, 94, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          child: Text(
                            'Pick Start Date',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              elevation: 15,
                              primary: Color.fromRGBO(36, 38, 94, 1),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                // initialDate: _selectedStartDate,
                                initialDate: _selectedStartDate == null
                                    ? DateTime.now()
                                    : _selectedStartDate!,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                                builder: (context, child) => Theme(
                                      data: ThemeData().copyWith(
                                          dialogTheme: DialogTheme(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16))),
                                          colorScheme: ColorScheme.light(
                                            primary:
                                                Color.fromRGBO(36, 38, 94, 1),
                                          )),
                                      child: child!,
                                    )).then((date) {
                              setState(() {
                                _selectedStartDate = date!;
                              });
                            });
                          }),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Column(
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(230, 50, 50, 1),
                                Color.fromRGBO(210, 107, 191, 1)
                              ]).createShader(bounds),
                          child: Icon(
                            CupertinoIcons.calendar,
                            size: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            _selectedEndDate == null
                                ? "No date"
                                : "${_selectedEndDate!.year.toString()}/${_selectedEndDate!.month.toString().padLeft(2, '0')}/${_selectedEndDate!.day.toString().padLeft(2, '0')}",
                            textScaleFactor: 1,
                            style: TextStyle(
                              color: Color.fromRGBO(36, 38, 94, 1),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            child: Text(
                              'Pick End Date',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                elevation: 15,
                                primary: Color.fromRGBO(36, 38, 94, 1),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              showDatePicker(
                                  context: context,
                                  // initialDate: _selectedStartDate,
                                  initialDate: _selectedEndDate == null
                                      ? DateTime.now()
                                      : _selectedEndDate!,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                        data: ThemeData().copyWith(
                                            dialogTheme: DialogTheme(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16))),
                                            colorScheme: ColorScheme.light(
                                              primary:
                                                  Color.fromRGBO(36, 38, 94, 1),
                                            )),
                                        child: child!,
                                      )).then((date) {
                                setState(() {
                                  _selectedEndDate = date!;
                                });
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_state == AppState.GETTING_HEALTH_DATA ||
                      _state == AppState.GENERATING_CSV ||
                      _state == AppState.UPLOADING_TO_S3 ||
                      _state == AppState.DONE_UPLOADED) ...[
                    Text(
                      '1. Fetching all health data',
                    )
                  ],
                  if (_state == AppState.GENERATING_CSV ||
                      _state == AppState.UPLOADING_TO_S3 ||
                      _state == AppState.DONE_UPLOADED) ...[
                    Text('2. Generating csv file')
                  ],
                  if (_state == AppState.UPLOADING_TO_S3 ||
                      _state == AppState.DONE_UPLOADED) ...[
                    Text('3. Uploading csv file to Cloud')
                  ],
                  if (_state == AppState.DONE_UPLOADED) ...[Text('4. Done')],
                ],
              ),
              SizedBox(
                height: 50,
              ),
              _state == AppState.DONE_UPLOADED
                  ? Container(
                      child: Icon(Icons.check, color: Colors.green, size: 50),
                    )
                  : MaterialButton(
                      child: setUpButtonChild(),
                      onPressed: () {
                        if (_selectedStartDate != null &&
                            _selectedEndDate != null) {
                          _state == AppState.SELECTING_DATES
                              ? fetchBatchData(
                                  _selectedStartDate!, _selectedEndDate!)
                              : null;
                        } else {
                          final snackBar = SnackBar(
                            content: Text(
                              "No Date was selected",
                              textScaleFactor: 1.2,
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                      },
                      elevation: 4.0,
                      minWidth: 300,
                      height: 56,
                      color: Color.fromRGBO(36, 38, 94, 1),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == AppState.SELECTING_DATES) {
      return new Text(
        "Generate and Upload csv File",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _selectingDates();
  }
}
