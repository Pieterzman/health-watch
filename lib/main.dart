// import 'package:../screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:healthwatch/screens/validation_form.dart';
import 'screens/entry.dart';
import 'screens/confirm.dart';
import 'screens/confirm_reset.dart';
import 'screens/dashboard.dart';
import 'screens/log_data.dart';
import 'helpers/configure_amplify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await configureAmplify();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amp Awesome',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color.fromRGBO(36, 38, 94, 1)),
      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmScreen(data: settings.arguments as SignupData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/confirm-reset') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmResetScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/dashboard') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => DashboardScreen(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/symptom_log') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                LogDataScreen(nextScreenState: settings.arguments as int),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        if (settings.name == '/validation_form') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ValidationFormScreen(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }

        // if (settings.name == '/settings_screen') {
        //   return PageRouteBuilder(
        //     pageBuilder: (_, __, ___) => SettingsScreen(),
        //     transitionsBuilder: (_, __, ___, child) => child,
        //   );
        // }

        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}
