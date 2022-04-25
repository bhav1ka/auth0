import 'package:flutter/material.dart';
import 'package:mpsc_demo/components/rounded_button.dart';
import 'package:mpsc_demo/datamodels/user_profile.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';
import 'package:mpsc_demo/services/authentication.dart';
import 'package:mpsc_demo/services/show_snackbar.dart';
import 'package:provider/provider.dart';
import '../utils/app_state_notifier.dart';
import 'dashboard/dashboard.dart';

// ignore: use_key_in_widget_constructors
class Login extends StatelessWidget {
  static String id = 'login';
  @override
  Widget build(BuildContext context) {
    void login() async {
      print('Function call');
      //   isBusy = true;
      var result = await Authentication.loginAction();
      // print('Result is $result');
      await Authentication.secureStorage
          .write(key: 'refresh_token', value: result.refreshToken);
      final idToken = Authentication.parseIdToken(result.idToken);
      final profile = await Authentication.getUserDetails(result.accessToken);
      // print('Name is: ${idToken['name']}');
      // print('Picture URL is ${profile['picture']}');
      Provider.of<UserProfile>(context, listen: false).setIdToken = idToken;
      Provider.of<UserProfile>(context, listen: false).setProfile = profile;
      if (Provider.of<UserProfile>(context, listen: false).getProfile == {} &&
          Provider.of<UserProfile>(context, listen: false).getIdToken == {})
        // ignore: curly_braces_in_flow_control_structures
        CustomSnackBar.showSnackBar(
            'Login Failed: Unable to fetch user Profile', context);
      else
        // ignore: curly_braces_in_flow_control_structures
        Navigator.pushNamedAndRemoveUntil(
            context, DashBoard.id, (route) => false);
    }

    double imageWidth = MediaQuery.of(context).size.width * 0.7;
    double imageHeight = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      //backgroundColor: kprimaryColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: Provider.of<AppStateNotifier>(context).darkModeEnabled
                  ? const AssetImage('assets/images/hoot_dark.png')
                  : const AssetImage('assets/images/hoot_light.png'),
              width: imageWidth,
              height: imageHeight,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'The World is a Conference!\nCollaboration for Everyone!',
              style: kSecondaryTextStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'A Cloud Native, Highly Customisable Collaboration Framework for Everyone!\nEmpower your team and customers with an innovative cloud based collaboration & conferencing tool, whilst keeping costs at the bare-minimum.',
              style: Provider.of<AppStateNotifier>(context).darkModeEnabled
                  ? kDarkModeTextStyle
                  : kPrimaryTextStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButton(kprimaryColor, 'Login', login)
            // Text(loginError),
          ],
        ),
      ),
    );
  }
}
