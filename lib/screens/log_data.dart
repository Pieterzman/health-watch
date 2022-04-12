// import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:healthwatch/models/ModelProvider.dart';
import 'package:healthwatch/models/SymptomModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:ui' as ui;

class LogDataScreen extends StatefulWidget {
  final int nextScreenState;
  LogDataScreen({required this.nextScreenState});

  @override
  _LogDataScreenState createState() => _LogDataScreenState();
}

enum AppState {
  SELECTING_SYMPTOMS,
  SELECTING_DATE,
  SELECTING_ILLNESSES,
  SELECTING_CATEGORY,
}

class _LogDataScreenState extends State<LogDataScreen> {
  // AppState? _astate;
  @override
  void initState() {
    super.initState();
    getState();
  }

  AppState? _state;
  AppState? _prevState;
  DateTime? _selectedDate;
  HealthDataUser? currentHealthDataUser;

  List<SymptomModel> symptoms = [
    SymptomModel('Fever', false),
    SymptomModel('Coughing', false),
    SymptomModel('Tiredness', false),
    SymptomModel('Loss of taste or smell', false),
    SymptomModel('Runny or stuffy nose', false),
    SymptomModel('Sore throat', false),
    SymptomModel('Headache', false),
    SymptomModel('Diarrhoea', false),
    SymptomModel('Body or muscle aches', false),
    SymptomModel('Skin rash', false),
    SymptomModel('Shortness of breath', false),
    SymptomModel('Chest pain', false),
    SymptomModel('Dizziness', false),
    SymptomModel('Lack of appetite', false),
    SymptomModel('Sneezing', false),
    SymptomModel('Nausea or vomiting', false),
    SymptomModel('Shivering or chills', false),
    SymptomModel('Dry Mouth', false),
    SymptomModel('Insomnia', false),
    SymptomModel('Lightheaded', false),
  ];

  List<String> illnessesDropdown = [
    'COVID-19',
    'Flu',
    'Common Cold',
    'Gastro / Stomach flu'
  ];
  String? selectedIllnessDropdown;

  List<String> illnessDiagnosisList = [
    'Self diagnosed',
    'Diagnosed by Doctor or Nurse',
    'Diagnosed by lab test',
    'Diagnosed by home test'
  ];

  String? illnessDiagnonsis;

  bool alcoholConsumption = false;
  double? alcoholUnitsConsumed;
  // List<IllnessModel> selectedIllness = [];
  List<SymptomModel> selectedSymptoms = [];

  // Future<void> saveAlcConsumption() {

  // }

  Future<void> getState() async {
    if (widget.nextScreenState == 2) {
      setState(() {
        _prevState = AppState.SELECTING_ILLNESSES;
        _state = AppState.SELECTING_ILLNESSES;
      });
    } else if (widget.nextScreenState == 1) {
      setState(() {
        _prevState = AppState.SELECTING_SYMPTOMS;
        _state = AppState.SELECTING_SYMPTOMS;
      });
    } else if (widget.nextScreenState == 0) {
      alcoholConsumption = true;
      setState(() {
        _prevState = null;
        _state = AppState.SELECTING_DATE;
      });
    }
  }

  Future<void> saveSymptoms(List<SymptomModel> selectedSymptoms) async {
    selectedSymptoms.forEach((symptom) async {
      writeSymptom(symptom.name, _selectedDate!);
    });
  }

  Future<void> writeAlcConsumption(DateTime selectedDate) async {
    /// Get HealthDataUser
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getString("useruuid");

      currentHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(uuid)))[0];
    } catch (e) {
      print("caught exception in getting currentHealthDatauser");
    }

    ///Save AlcConsumpt to DataStore
    try {
      AlcConsumptionPt newAlcConsumptionPt = AlcConsumptionPt(
          healthdatauserID: currentHealthDataUser!.id,
          loggedAlcConsumptionPt: 'Alcohol consumed',
          loggedDate: TemporalDate(selectedDate.add(Duration(hours: 12))));

      await Amplify.DataStore.save(newAlcConsumptionPt);
      // print("Created: $Alc");
    } catch (e) {
      print("Caught exception in saving newSIllnessPt: $e");
    }
  }

  Future<void> writeIllness(String loggedIllness, String loggedIllnessDiagnosis,
      DateTime selectedDate) async {
    /// Get HealthDataUser
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getString("useruuid");

      currentHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(uuid)))[0];
    } catch (e) {
      print("caught exception in getting currentHealthDatauser");
    }

    ///Save Symptom to DataStore
    try {
      IllnessPt newIllnessPt = IllnessPt(
          healthdatauserID: currentHealthDataUser!.id,
          loggedIllness: loggedIllness,
          loggedIllnessDiagnosis: loggedIllnessDiagnosis,
          loggedDate: TemporalDate(selectedDate.add(Duration(hours: 12))));

      await Amplify.DataStore.save(newIllnessPt);
      print("Created: $newIllnessPt");
    } catch (e) {
      print("Caught exception in saving newSIllnessPt: $e");
    }
  }

  Future<void> writeSymptom(String loggedSymptom, DateTime selectedDate) async {
    /// Get HealthDataUser
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getString("useruuid");

      currentHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(uuid)))[0];
    } catch (e) {
      print("caught exception in getting currentHealthDatauser");
    }

    ///Save Symptom to DataStore
    try {
      SymptomPt newSymptomPt = SymptomPt(
          healthdatauserID: currentHealthDataUser!.id,
          loggedSymptom: loggedSymptom,
          loggedDate: TemporalDate(selectedDate.add(Duration(hours: 12))));

      await Amplify.DataStore.save(newSymptomPt);
      print("Created: $newSymptomPt");
    } catch (e) {
      print("Caught exception in saving newSymptomPt: $e");
    }
  }

  Widget _selectingSymptoms() {
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
              'Log Symptoms',
              style: TextStyle(
                // color: Colors.black,
                fontSize: 24,
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
          centerTitle: true,
          leading: MaterialButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(
                    top: 10, bottom: kFloatingActionButtonMargin + 70),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: symptoms.length,
                itemBuilder: (_, index) {
                  // return symptoms[index];
                  return CheckboxListTile(
                    dense: true,
                    title: Text(
                      symptoms[index].name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    value: symptoms[index].isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        symptoms[index].isSelected = value!;
                        if (symptoms[index].isSelected == true) {
                          selectedSymptoms
                              .add(SymptomModel(symptoms[index].name, true));
                        } else if (symptoms[index].isSelected == false) {
                          selectedSymptoms.removeWhere((element) =>
                              element.name == symptoms[index].name);
                        }
                      });
                    },
                    activeColor: Colors.green,
                  );
                },
              ),
            ),
            Divider()
            // SizedBox(
            //   height: 120,
            // )
          ],
        ),
        bottomSheet: const SizedBox(
          height: 20,
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'Enter Date',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(36, 38, 94, 1),
          onPressed: () {
            if (selectedSymptoms.isNotEmpty) {
              setState(() => _state = AppState.SELECTING_DATE);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            } else {
              print("No symptom was selected");
              final snackBar = SnackBar(
                content: Text(
                  "No symptom was selected",
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
          icon: const Icon((Icons.navigate_next), color: Colors.white),
        ));
  }

  Widget _selectingIllness() {
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
              'Log Illness',
              style: TextStyle(
                // color: Colors.black,
                fontSize: 24,
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
          centerTitle: true,
          leading: MaterialButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Please select your illness:',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  // decoration: InputDecoration(
                  //     labelText: 'Smartwatch Brand',
                  //     border: OutlineInputBorder(),
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),

                  value: selectedIllnessDropdown,
                  isExpanded: true,
                  elevation: 16,
                  hint: Text('Illness'),
                  icon: const Icon(Icons.add),
                  iconSize: 30,
                  items: illnessesDropdown
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedIllnessDropdown = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'How was the illness diagnosed?',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: illnessDiagnonsis,
                  isExpanded: true,
                  elevation: 16,
                  hint: Text('Diagnosed'),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 30,
                  items: illnessDiagnosisList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16),
                      ),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      illnessDiagnonsis = newValue;
                    });
                  },
                ),
              ),
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'Enter Date',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(36, 38, 94, 1),
          onPressed: () {
            if (selectedIllnessDropdown != null && illnessDiagnonsis != null) {
              setState(() => _state = AppState.SELECTING_DATE);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            } else if (selectedIllnessDropdown == null &&
                illnessDiagnonsis == null) {
              final snackBar = SnackBar(
                content: Text(
                  "No illness was selected",
                  textScaleFactor: 1.2,
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
            } else if (illnessDiagnonsis == null &&
                selectedIllnessDropdown != null) {
              final snackBar = SnackBar(
                content: Text(
                  "Please select how illness was diagnosed",
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
          icon: const Icon((Icons.navigate_next), color: Colors.white),
        ));
  }

  Widget _selectingDate() {
    // return Text('Select Symptoms widget');
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
              'Select Date',
              style: TextStyle(
                // color: Colors.black,
                fontSize: 24,
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
          leading: MaterialButton(
            onPressed: () {
              if (_prevState == null) {
                Navigator.pushReplacementNamed(context, '/dashboard');
              } else if (_prevState == AppState.SELECTING_SYMPTOMS) {
                setState(() => _state = AppState.SELECTING_SYMPTOMS);
              } else if (_prevState == AppState.SELECTING_ILLNESSES) {
                setState(() => _state = AppState.SELECTING_ILLNESSES);
              }
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 32),
              _selectedDate == null
                  ? ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(230, 50, 50, 1),
                            Color.fromRGBO(210, 107, 191, 1)
                          ]).createShader(bounds),
                      child: Icon(
                        CupertinoIcons.calendar_badge_plus,
                        size: 120,
                      ),
                    )
                  : ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(59, 126, 245, 1),
                            Color.fromRGBO(106, 195, 163, 1),
                          ]).createShader(bounds),
                      child: Icon(
                        CupertinoIcons.calendar,
                        size: 120,
                      ),
                    ),
              const SizedBox(height: 20),
              Text(
                  _selectedDate == null
                      ? "No date selected"
                      : "${_selectedDate!.year.toString()}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                  textScaleFactor: 1,
                  style: TextStyle(
                    color: Color.fromRGBO(36, 38, 94, 1),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    // foreground: Paint()
                    //   ..shader = ui.Gradient.linear(const Offset(100, -30),
                    //       const Offset(400, 30), <Color>[
                    //     Color.fromRGBO(230, 50, 50, 1),
                    //     Color.fromRGBO(210, 107, 191, 1)
                    //   ]),
                  )),
              const SizedBox(height: 32),
              ElevatedButton(
                  child: Text(
                    'Pick a Date',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      elevation: 15,
                      primary: Color.fromRGBO(36, 38, 94, 1),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        initialDate: _selectedDate == null
                            ? DateTime.now()
                            : _selectedDate!,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) => Theme(
                              data: ThemeData().copyWith(
                                  colorScheme: ColorScheme.light(
                                primary: Color.fromRGBO(36, 38, 94, 1),
                              )),
                              child: child!,
                            )).then((date) {
                      setState(() {
                        _selectedDate = date!;
                      });
                    });
                  }),
              const SizedBox(
                height: 50,
              ),
              if (_prevState == null) ...[
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Alcohol Consumed:',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(36, 38, 94, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(
                              color: Color.fromRGBO(36, 38, 94, 1), width: 5),
                        )),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Icon(
                              Icons.liquor,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )

                // Column(
                //   children: [
                //     Icon(
                //       Icons.liquor,
                //       size: 50,
                //     ),
                //     Text(
                //       'Alcohol Consumed',
                //       style: TextStyle(
                //           fontSize: 24,
                //           color: Color.fromRGBO(36, 38, 94, 1),
                //           fontWeight: FontWeight.w500),
                //     ),
                //   ],
                // )
              ] else if (_prevState == AppState.SELECTING_SYMPTOMS) ...[
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Symptoms selected:',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(36, 38, 94, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Container(
                        // padding: EdgeInsets.only(left: 50),
                        // color: Colors.green,
                        // alignment: Alignment.topCenter,
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(
                              color: Color.fromRGBO(36, 38, 94, 1), width: 5),
                        )),
                        child: ListView.builder(
                            padding: EdgeInsets.only(left: 10, top: 0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: selectedSymptoms.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.check_box,
                                          color: Colors.green),
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 0, left: 5),
                                        child: Text(
                                          selectedSymptoms[index].name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ),
                    )
                    // Text(
                    //   '${selectedSymptoms[0].name.toString()}',
                    //   style: TextStyle(
                    //       fontSize: 18, color: Color.fromRGBO(36, 38, 94, 1)),
                    // ),
                  ],
                )
              ] else if (_prevState == AppState.SELECTING_ILLNESSES) ...[
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Diagnosed Illness:',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(36, 38, 94, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(
                              color: Color.fromRGBO(36, 38, 94, 1), width: 5),
                        )),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Icon(Icons.sick_outlined),
                                const SizedBox(width: 5),
                                Text(
                                  selectedIllnessDropdown!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 25,
                                ),
                                Icon(Icons.paste),
                                const SizedBox(width: 5),
                                Text(
                                  illnessDiagnonsis!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ]
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'Done',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(36, 38, 94, 1),
          onPressed: () {
            if (_selectedDate != null) {
              if (_prevState == null && alcoholConsumption == true) {
                writeAlcConsumption(_selectedDate!);
                // print("saving Alcohol Consumption Date");
              } else if (_prevState == AppState.SELECTING_SYMPTOMS &&
                  selectedSymptoms.isNotEmpty) {
                saveSymptoms(selectedSymptoms);
              } else if (_prevState == AppState.SELECTING_ILLNESSES &&
                  selectedIllnessDropdown != null &&
                  illnessDiagnonsis != null) {
                writeIllness(selectedIllnessDropdown!, illnessDiagnonsis!,
                    _selectedDate!);
                // print('saving illness');
              }

              Navigator.pushReplacementNamed(context, '/dashboard');
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            } else {
              final snackBar = SnackBar(
                content: Text(
                  "No date was selected",
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
          icon: const Icon((Icons.navigate_next), color: Colors.white),
        ));
  }

  Widget _content() {
    if (_state == AppState.SELECTING_ILLNESSES)
      return _selectingIllness();
    else if (_state == AppState.SELECTING_SYMPTOMS)
      return _selectingSymptoms();
    else if (_state == AppState.SELECTING_DATE) return _selectingDate();
    return Text('Error');
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }
}
