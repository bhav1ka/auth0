import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:mpsc_demo/screens/joinconference/join_conference_text_form_field_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mpsc_demo/globalvariables/constants.dart';
import 'package:mpsc_demo/utils/app_state_notifier.dart';
import 'package:provider/provider.dart';

import '../../datamodels/user_profile.dart';

class JoinConference extends StatefulWidget {
  static String id = 'joinconference';
  @override
  _JoinConferenceState createState() => _JoinConferenceState();
}

class _JoinConferenceState extends State<JoinConference> {
  // ignore: unused_field
  ScaffoldState _scaffoldState;

  final _formKey = GlobalKey<FormState>();
  bool _accessCodeVisible = false;
  final TextEditingController _accesscodeTextField = TextEditingController();

  /// Controller for the meeting URL text field.
  final TextEditingController _meetingURLController = TextEditingController();

  /// Timer of when the user stopped editing the meeting URL.
  Timer _userStoppedEditingMeetingUrlTimer;
  static const Duration _checkForAccessCodeNeededDuration =
      Duration(seconds: 2);
  @override
  Widget build(BuildContext context) {
    /// Path to the app icon to show in the start view.
    String appIconPath = Provider.of<AppStateNotifier>(context).darkModeEnabled
        ? 'assets/images/hoot_dark.png'
        : 'assets/images/hoot_light.png';
    final TextEditingController _usernameTextField = TextEditingController(
        text: Provider.of<UserProfile>(context)
            .getIdToken['name']
            .toString()
            .toLowerCase());

    /// Build the login button to join the meeting with when clicked.
    Widget _buildJoinButton(BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(top: 20),
        child: SizedBox(
          width: double.infinity,
          height: 75.0,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kprimaryColor)),
            onPressed: () => _submitForm(context, _usernameTextField),
            child: Text('Join',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: GoogleFonts.openSans().toString(),
                    fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }

    Widget _buildUsernameTextField() {
      return JoinConferenceTextFormField(
        controller: _usernameTextField,
        hintText: 'User Name',
        prefixIcon: Icon(Icons.label),
        validator: (value) => value.isEmpty ? 'User Name is missing' : null,
      );
    }

    /// Build the header widgets for the start view.
    List<Widget> _buildHeaderWidgets(BuildContext context) => [
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20),
              child: Image.asset(
                appIconPath,
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
          if (MediaQuery.of(context).orientation == Orientation.landscape)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    appIconPath,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'App Title',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 32.0),
                    ),
                  ),
                ],
              ),
            ),
        ];
    Widget _buildForm(BuildContext context) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            _buildUsernameTextField(),
            Visibility(
                visible: _accessCodeVisible,
                child: _buildAccessCodeTextField()),
            _buildURLTextField(),
            _buildJoinButton(context),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Provider.of<AppStateNotifier>(context).darkModeEnabled
          ? kdarkModeColor
          : Colors.white,
      body: Builder(
        builder: (context) {
          _scaffoldState = Scaffold.of(context);
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ..._buildHeaderWidgets(context),
                    _buildForm(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build the text field where the user should input the BBB URL to join the meeting of.
  Widget _buildURLTextField() {
    return JoinConferenceTextFormField(
      controller: _meetingURLController,
      hintText: 'Meeting Url',
      prefixIcon: Icon(Icons.link),
      onChanged: (url) {
        if (_userStoppedEditingMeetingUrlTimer == null) {
          _userStoppedEditingMeetingUrlTimer =
              Timer(_checkForAccessCodeNeededDuration, () {
            _handleUrlUpdate(url);
          });
        } else {
          _userStoppedEditingMeetingUrlTimer.cancel();
          _userStoppedEditingMeetingUrlTimer =
              Timer(_checkForAccessCodeNeededDuration, () {
            _handleUrlUpdate(url);
          });
        }
      },
      validator: (value) => value.isEmpty ? 'Meeting URL missing' : null,
    );
  }

  Widget _buildAccessCodeTextField() {
    return JoinConferenceTextFormField(
      controller: _accesscodeTextField,
      hintText: 'Access Code',
      prefixIcon: Icon(Icons.vpn_key),
      validator: (value) => value.isEmpty ? 'Access Code missing' : null,
    );
  }

  /// Submit the form and validate input fields.
  Future<void> _submitForm(
      BuildContext context, TextEditingController _usernameTextField) async {
    if (_formKey.currentState.validate()) {
      String meetingURL = _meetingURLController.text;
      // ignore: unused_local_variable
      final username = _usernameTextField.text;
      // ignore: unused_local_variable
      final String accesscode = _accesscodeTextField.text;
      //handle input mistakes made by user
      meetingURL = meetingURL.trim();
      if (!meetingURL.startsWith("http://") &&
          !meetingURL.startsWith("https://")) {
        meetingURL = "https://" + meetingURL;
      }
      _meetingURLController.text = meetingURL;

      // await _joinMeeting(
      //   meetingURL,
      //   username: username,
      //   accessCode: accesscode,
      // );
    }
  }

  Future<void> _handleUrlUpdate(String meetingUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(meetingUrl));
      response.body.contains('room_access_code')
          ? setState(() {
              _accessCodeVisible = true;
            })
          : setState(() {
              _accessCodeVisible = false;
            });
    } catch (e) {
      // Ignore
    }
  }
}
