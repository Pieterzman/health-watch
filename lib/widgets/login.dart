// import 'package:amplify_datastore/amplify_datastore.dart';
import 'dart:ui' as ui;
// import 'package:healthwatch/api/notification_api.dart';
// import 'package:healthwatch/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:healthwatch/models/HealthDataUser.dart';
import 'package:healthwatch/widgets/terms_of_use.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SignupData? _data;
  bool _isSignedIn = false;
  bool? demographicDataLogged;

  Future<String?> _onLogin(LoginData data) async {
    try {
      await Amplify.Auth.signOut();
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );

      _isSignedIn = res.isSignedIn;
      final prefs = await SharedPreferences.getInstance(); //retrieve UUID
      final useruuid = prefs.getString("useruuid");
      prefs.setString('userEmail', data.name);
      prefs.setBool('userLoggedIn', _isSignedIn);
      demographicDataLogged = prefs.getBool("demographicDataLogged");
      updateLastSignedIn(useruuid!);
    } on AuthException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      }

      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String?> _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        Navigator.of(context).pushReplacementNamed(
          '/confirm-reset',
          arguments: LoginData(name: email, password: ''),
        );
      }
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String?> _onSignup(SignupData data) async {
    try {
      await Amplify.Auth.signOut();
      await Amplify.Auth.signUp(
        username: data.name!,
        password: data.password!,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: data.name!,
        }),
      );

      _data = data;
      demographicDataLogged = false;
      DateTime today = DateTime.now().toUtc();
      DateTime thirtyDaysAgo = today.subtract(const Duration(days: 1));
      String lastrefreshed = thirtyDaysAgo.toIso8601String();
      String useruuid = Uuid().v1();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('useruuid', useruuid);
      prefs.setString('lastrefreshed', lastrefreshed);
      prefs.setBool('demographicDataLogged', demographicDataLogged!);
      prefs.setBool('opt_out', false);
      // prefs.setBool('notificationsFlag', true);
      // prefs.setBool('alreadyScheduled', false);

      logSignup(useruuid, thirtyDaysAgo);
      updateLastSignedIn(useruuid);
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<void> logSignup(String uuid, DateTime lastrefreshed) async {
    try {
      HealthDataUser newHealthDataUser = HealthDataUser(
          useruuID: uuid,
          opt_out: false,
          signedUp: TemporalDateTime.now(),
          lastSignedIn: TemporalDateTime.now(),
          lastRefreshed: TemporalDateTime(lastrefreshed));

      await Amplify.DataStore.save(newHealthDataUser);

      print(newHealthDataUser);
    } catch (e) {
      print("Caught Exception in logSignup!!!");
    }
  }

  Future<void> updateLastSignedIn(String uuid) async {
    try {
      HealthDataUser oldHealthDataUser = (await Amplify.DataStore.query(
          HealthDataUser.classType,
          where: HealthDataUser.USERUUID.eq(uuid)))[0];
      print(oldHealthDataUser); //debug print

      HealthDataUser newHealthDataUser = oldHealthDataUser.copyWith(
          id: oldHealthDataUser.id,
          useruuID: oldHealthDataUser.useruuID,
          lastSignedIn: TemporalDateTime.now(),
          lastRefreshed: oldHealthDataUser.lastRefreshed);
      print(newHealthDataUser); //debug print

      await Amplify.DataStore.save(newHealthDataUser);
      print("updateLastSignedIn saved!!!!!!!!!!!!!!!!!!");
    } catch (e) {
      print("Caught Exception in updateLastSignedIn!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Welcome',
      onLogin: _onLogin,
      onRecoverPassword: (String email) => _onRecoverPassword(context, email),
      onSignup: _onSignup,
      termsOfService: [
        TermOfService(
          id: "Consent",
          mandatory: true,
          text: "Informed Consent",
          linkUrl:
              "https://docs.google.com/document/d/1U57aeTfwK0pMvheEoN0UQyAJo4ED7dSXFmuBvfcO-iE/edit?usp=sharing",
        ),
        // TermOfService(
        //   id: "Privacy",
        //   mandatory: true,
        //   text: "Privacy Policy",
        //   linkUrl:
        //       "https://docs.google.com/document/d/14qqFDv-l5jl5pwq_dxQeydsd0Khv4zrWgEj65vBbr-0/edit?usp=sharing",
        // )
      ],
      children: [
        // Column(
        //   children: [
        //     SizedBox(
        //       height: 300,
        //     ),
        //     TermsOfUse(),
        //   ],
        // )
        Padding(
          padding: const EdgeInsets.only(top: 600),
          child: TermsOfUse(),
        )
        // Column(
        //   children: [
        //     Expanded(child: Container()),
        //     Align(alignment: Alignment.bottomCenter, child: TermsOfUse()),
        //   ],
        // )
      ],
      // footer: TermsOfUse(),
      // children: [
      //   // Expanded(child: SizedBox()),

      //   Padding(padding: const EdgeInsets.only(top: 500.0), child: TermsOfUse())
      // ],
      theme: LoginTheme(
          primaryColor: Theme.of(context).primaryColor,
          titleStyle: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = ui.Gradient.linear(
                  const Offset(0, -20), const Offset(150, 20), <Color>[
                Color.fromRGBO(59, 126, 245, 1),
                Color.fromRGBO(106, 195, 163, 1),
              ]),
          )),
      onSubmitAnimationCompleted: () {
        if (demographicDataLogged! == false) {
          Navigator.of(context).pushReplacementNamed(
            _isSignedIn ? '/validation_form' : '/confirm',
            arguments: _data,
          );
        } else {
          Navigator.of(context).pushReplacementNamed(
            _isSignedIn ? '/dashboard' : '/confirm',
            arguments: _data,
          );
        }
      },
    );
  }
}
