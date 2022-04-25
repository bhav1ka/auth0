import 'dart:async';
import 'package:mpsc_demo/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:mpsc_demo/screens/login.dart';
import 'package:mpsc_demo/services/authentication.dart';
import 'package:mpsc_demo/globalvariables/config.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:provider/provider.dart';
import '../datamodels/user_profile.dart';
import '../utils/app_state_notifier.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'Splash Screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  Future<void> initAction() async {
    print('In init State');
    final storedRefreshToken =
        await Authentication.secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) {
      isLoggedIn = false;
      return;
    }
    try {
      final response = await Authentication.appAuth.token(TokenRequest(
        authClientId,
        authRedirectUri,
        issuer: authIssuer,
        refreshToken: storedRefreshToken,
      ));
      final idToken = Authentication.parseIdToken(response.idToken);
      final profile = await Authentication.getUserDetails(response.accessToken);
      Authentication.secureStorage
          .write(key: 'refresh_token', value: response.refreshToken);
      isLoggedIn = true;
      Provider.of<UserProfile>(context, listen: false).setIdToken = idToken;
      Provider.of<UserProfile>(context, listen: false).setProfile = profile;
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      isLoggedIn = false;
      Authentication.logoutAction();
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      await checkIfLoggedIn();
    });
  }

  Future<void> checkIfLoggedIn() async {
    await initAction();
    print('Value of isLoggedIn is $isLoggedIn');
    if (isLoggedIn == true) {
      Navigator.pushNamedAndRemoveUntil(
          context, DashBoard.id, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, Login.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.7;
    double imageHeight = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: Provider.of<AppStateNotifier>(context).darkModeEnabled
                ? const AssetImage('assets/images/hoot_dark.png')
                : const AssetImage('assets/images/hoot_light.png'),
            width: imageWidth,
            height: imageHeight,
          ),
          const SizedBox(
            height: 80,
          ),
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Made in India',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          )
        ],
      ),
    ));
  }
}
