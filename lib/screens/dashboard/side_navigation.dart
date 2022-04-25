import 'package:mpsc_demo/datamodels/user_profile.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';
import 'package:mpsc_demo/screens/login.dart';
import 'package:mpsc_demo/services/authentication.dart';
import 'package:mpsc_demo/utils/app_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SideNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width / 1.25,
      child: Drawer(
        child: Container(
          color: Provider.of<AppStateNotifier>(context).darkModeEnabled
              ? const Color(0xFF253341)
              : Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 4.0),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(Provider.of<UserProfile>(context)
                            .getProfile['picture'] ??
                        ''),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                Provider.of<UserProfile>(context).getIdToken['name'],
                style: Provider.of<AppStateNotifier>(context).darkModeEnabled
                    ? kDarkModeTextStyle
                    : kPrimaryTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: Provider.of<AppStateNotifier>(context).darkModeEnabled
                    ? Colors.white
                    : kprimaryColor,
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Text(
                  'Logout',
                  style: kSecondaryTextStyle,
                ),
                onTap: () {
                  Authentication.logoutAction();
                  Navigator.pushNamedAndRemoveUntil(
                      context, Login.id, (route) => false);
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
