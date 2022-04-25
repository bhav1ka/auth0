import 'package:flutter/material.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';
import 'package:mpsc_demo/utils/app_state_notifier.dart';
import 'package:mpsc_demo/screens/joinconference/join_conference.dart';
import 'screens/login.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/splashscreen.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth0 Demo',
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Login.id: (context) => Login(),
        DashBoard.id: (context) => DashBoard(),
        JoinConference.id: (context) => JoinConference()
      },
      initialRoute: SplashScreen.id,
      theme: ThemeData.light().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: kprimaryColor,
            ),
        buttonTheme: ButtonThemeData(
          buttonColor: kprimaryColor,
          textTheme:
              ButtonTextTheme.primary, //  <-- dark text for light background
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: kprimaryColor,
            ),
        appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
        scaffoldBackgroundColor: const Color(0xFF15202B),
        buttonTheme: ButtonThemeData(
          buttonColor: kprimaryColor,
          textTheme:
              ButtonTextTheme.primary, //  <-- dark text for light background
        ),
      ),
      themeMode: Provider.of<AppStateNotifier>(context).darkModeEnabled
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}
