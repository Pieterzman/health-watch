// import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:healthwatch/models/ModelProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:healthwatch/smartwatches/applewatches.dart';
import 'package:healthwatch/smartwatches/coroswatches.dart';
import 'package:healthwatch/smartwatches/fitbitwatches.dart';
import 'package:healthwatch/smartwatches/garminwatches.dart';
import 'package:healthwatch/smartwatches/polarwatches.dart';
import 'package:healthwatch/smartwatches/samsungwatches.dart';
import 'package:healthwatch/smartwatches/suuntowatches.dart';
import 'package:healthwatch/smartwatches/huaweiwatches.dart';
import 'package:healthwatch/smartwatches/xiaomiwatches.dart';

class ValidationFormScreen extends StatefulWidget {
  const ValidationFormScreen({Key? key}) : super(key: key);

  @override
  _ValidationFormScreenState createState() => _ValidationFormScreenState();
}

class _ValidationFormScreenState extends State<ValidationFormScreen> {
  int currentStep = 0;
  bool demographicDataLogged = false;
  final formKey1 = GlobalKey<FormState>();
  // final formKey2 = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final sexuality = ['Male', 'Female'];

  final smartwatchBrands = [
    'Apple',
    'Garmin',
    'Polar',
    'Coros',
    'Suunto',
    'Fitbit',
    'Samsung',
    'Huawei',
    'Xiaomi',
    'Other',
  ];

  String userAge = '';
  String userWeight = '';
  String userHeight = '';
  String? userSex;
  String? userSmartwatchBrand;
  String? userSmartwatch;
  String? userOtherSmartwatchBrand;
  String? userOtherSmartwatch;
  bool termsCheckbox = false;

  // String test = 'Apple';
  // bool optOut = false;

  Future<void> saveDemographicData() async {
    try {
      final prefs = await SharedPreferences.getInstance(); //retrieve UUID
      final uuid = prefs.getString("useruuid");

      HealthDataUser oldHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(uuid)))[0];
      print(oldHealthDataUser); //debug print

      HealthDataUser newHealthDataUser = oldHealthDataUser.copyWith(
          id: oldHealthDataUser.id,
          useruuID: oldHealthDataUser.useruuID,
          lastSignedIn: TemporalDateTime.now(),
          lastRefreshed: oldHealthDataUser.lastRefreshed,
          age: userAge,
          weight: userWeight,
          height: userHeight,
          sex: userSex,
          smartwatch: userSmartwatchBrand == 'Other'
              ? ("Other " +
                  userOtherSmartwatchBrand! +
                  " " +
                  userOtherSmartwatch!)
              : (userSmartwatchBrand! + " " + userSmartwatch!),
          opt_out: oldHealthDataUser.opt_out);

      print(newHealthDataUser); //debug print

      await Amplify.DataStore.save(newHealthDataUser);

      prefs.setBool('demographicDataLogged', true);
      setState(() {
        demographicDataLogged = prefs.getBool("demographicDataLogged")!;
      });
    } catch (e) {
      print("Caught exception in saveDemographicData: $e");
    }
  }

  Future updateDemographicData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("demographicDataLogged", false);
    // setState(() => _state = AppState.LOG_DEMOGRAPHIC_DATA);
  }

  Widget buildAge() => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        decoration: InputDecoration(
          labelText: 'Age',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length != 2) {
            return 'Please enter the correct age';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => userAge = value!),
      );

  Widget buildWeight() => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        decoration: InputDecoration(
          labelText: 'Weight',
          suffixText: 'Kg',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length > 3 || value.length < 2) {
            return 'Please enter the correct weight in Kg';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => userWeight = value!),
      );

  Widget buildHeight() => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
        ],
        decoration: InputDecoration(
          labelText: 'Height',
          suffixText: 'cm',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length != 3) {
            return 'Please enter the correct height in cm';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => userHeight = value!),
      );

  Widget buildSmartwatchBrand() => DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          labelText: 'Smartwatch Brand',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      value: userSmartwatchBrand,
      isExpanded: true,
      elevation: 16,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 35,
      items: smartwatchBrands.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          child: Text(value),
          value: value,
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a value';
        } else {
          return null;
        }
      },
      onChanged: (String? newValue) {
        setState(() {
          userSmartwatch = null;
          userSmartwatchBrand = newValue!;
        });
      },
      onSaved: (String? newValue) {
        setState(() {
          userSmartwatch = null;
          userSmartwatchBrand = newValue!;
        });
      });

  Widget buildSmartwatches(List<String> smartwatches) =>
      DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              labelText: 'Model',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          value: userSmartwatch,
          isExpanded: true,
          elevation: 16,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 35,
          items: smartwatches.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              child: Text(value),
              value: value,
            );
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select a value';
            } else {
              return null;
            }
          },
          onChanged: (String? newValue) {
            setState(() {
              userSmartwatch = newValue!;
            });
          },
          onSaved: (String? newValue) {
            setState(() {
              userSmartwatch = newValue!;
            });
          });

  Widget buildOtherSmartwatchBrand() => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Enter other smartwatch brand',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == '') {
            return 'Please enter Brand of smartwatch';
          } else {
            return null;
          }
        },
        // onChanged: (value) => setState(() => userOtherSmartwatch = value),
        onSaved: (value) => setState(() => userOtherSmartwatchBrand = value!),
      );

  Widget buildOtherSmartwatch() => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Enter other smartwatch Model',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == '') {
            return 'Please enter Model of smartwatch';
          } else {
            return null;
          }
        },
        // onChanged: (value) => setState(() => userOtherSmartwatch = value),
        onSaved: (value) => setState(() => userOtherSmartwatch = value!),
      );

  Widget buildSex() => DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: () => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
          labelText: 'Sex',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      value: userSex,
      isExpanded: true,
      elevation: 16,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 35,
      items: sexuality.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          child: Text(value),
          value: value,
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a value';
        } else {
          return null;
        }
      },
      onChanged: (String? newValue) {
        setState(() {
          userSex = newValue!;
        });
      },
      onSaved: (String? newValue) {
        setState(() {
          userSex = newValue!;
        });
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Please complete the form"),
        backgroundColor: Color.fromRGBO(36, 38, 94, 1),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.light(primary: Color.fromRGBO(230, 50, 50, 1))),
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            if (formKeys[currentStep].currentState!.validate()) {
              formKeys[currentStep].currentState!.save();
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep && termsCheckbox == true) {
                saveDemographicData();
                //save everything!!!!!!!!!!!!
                Navigator.pushReplacementNamed(context, '/dashboard');
              } else {
                setState(() => currentStep += 1);
              }
            }
          },
          onStepCancel:
              currentStep == 0 ? null : () => setState(() => currentStep -= 1),
          controlsBuilder: (context, details) {
            final isLastStep = currentStep == getSteps().length - 1;

            return Container(
              margin: EdgeInsets.only(top: 32),
              child: Row(
                children: [
                  if (currentStep != 0)
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          'BACK',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: details.onStepCancel,
                      ),
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        isLastStep ? 'CONFIRM' : 'NEXT',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: isLastStep
                          ? (termsCheckbox ? details.onStepContinue : null)
                          : details.onStepContinue,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        // Step(
        //   state: currentStep > 0 ? StepState.complete : StepState.indexed,
        //   isActive: currentStep >= 0,
        //   title: Text("Instructions"),
        //   content: Container(
        //       child: PDFView(
        //     filePath: 'assets/informed_consent_form.pdf',
        //   )),
        // ),
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text("Personal"),
          content: Form(
            key: formKeys[0],
            child: Column(
              children: [
                buildAge(),
                const SizedBox(height: 32),
                buildHeight(),
                const SizedBox(height: 32),
                buildWeight(),
                const SizedBox(height: 32),
                buildSex(),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text("Watch"),
          content: Form(
            key: formKeys[1],
            child: Column(
              children: [
                // const SizedBox(height: 32),
                buildSmartwatchBrand(),
                const SizedBox(height: 32),
                if (userSmartwatchBrand == 'Apple') ...[
                  buildSmartwatches(appleWatches),
                ] else if (userSmartwatchBrand == 'Garmin') ...[
                  buildSmartwatches(garminWatches),
                ] else if (userSmartwatchBrand == 'Polar') ...[
                  buildSmartwatches(polarWatches),
                ] else if (userSmartwatchBrand == 'Coros') ...[
                  buildSmartwatches(corosWatches),
                ] else if (userSmartwatchBrand == 'Suunto') ...[
                  buildSmartwatches(suuntoWatches),
                ] else if (userSmartwatchBrand == 'Fitbit') ...[
                  buildSmartwatches(fitbitWatches),
                ] else if (userSmartwatchBrand == 'Samsung') ...[
                  buildSmartwatches(samsungWatches),
                ] else if (userSmartwatchBrand == 'Huawei') ...[
                  buildSmartwatches(huaweiWatches),
                ] else if (userSmartwatchBrand == 'Xiaomi') ...[
                  buildSmartwatches(xiaomiWatches),
                ] else if (userSmartwatchBrand == 'Other') ...[
                  buildOtherSmartwatchBrand(),
                  const SizedBox(height: 32),
                  buildOtherSmartwatch(),
                ] else
                  ...[]

                // buildSmartwatches(),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text("Consent"),
          content: Form(
              key: formKeys[2],
              child: Column(
                children: [
                  const Text(
                    'Consent Form',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'By clicking, I Agree, I confirm that I have completed and saved the Informed Consent form and that I am ready to proceed with the study.',
                    style: TextStyle(fontSize: 18),
                  ),
                  CheckboxListTile(
                    value: termsCheckbox,
                    onChanged: (value) => setState(() {
                      termsCheckbox = !termsCheckbox;
                    }),
                    subtitle: !termsCheckbox
                        ? Text(
                            'Required',
                            style: TextStyle(color: Colors.red),
                          )
                        : null,
                    title: const Text(
                      'I agree',
                      style: TextStyle(fontSize: 18),
                    ),
                    activeColor: Colors.green,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              )),
        ),
      ];
}
