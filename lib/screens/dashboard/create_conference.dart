import 'package:flutter/material.dart';
import 'package:mpsc_demo/components/rounded_button.dart';
import 'package:mpsc_demo/datamodels/user_profile.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';
import 'package:provider/provider.dart';
import '../../components/custom_text_form_field.dart';
import 'package:flutter/services.dart';
import '../../utils/app_state_notifier.dart';

// ignore: use_key_in_widget_constructors
class CreateConference extends StatefulWidget {
  @override
  _CreateConferenceState createState() => _CreateConferenceState();
}

class _CreateConferenceState extends State<CreateConference> {
  bool isRecording = true;
  TextEditingController lastName = TextEditingController();
  TextEditingController inviteList = TextEditingController();
  final String apiLink = 'https://hoot.mx/meeting/';
  @override
  Widget build(BuildContext context) {
    TextEditingController firstName = TextEditingController(
        text: Provider.of<UserProfile>(context)
            .getIdToken['name']
            .toString()
            .toLowerCase());
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        color: Provider.of<AppStateNotifier>(context).darkModeEnabled
            ? kdarkModeColor
            : Colors.white,
        border: Border.all(style: BorderStyle.solid, color: Colors.black12),
      ),
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Text(
              'Create Conference',
              style: kSecondaryTextStyle,
            ),
          ),
          const Divider(
            color: kprimaryColor,
            thickness: 2,
          ),
          const SizedBox(height: 10),
          Row(
            //   crossAxisAlignment: CrossAxisAlignment.baseline,
            //  textBaseline: TextBaseline.alphabetic,
            //  mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name',
                style: kFormHeadingStyles,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  flex: 3,
                  child: CustomTextFormField(firstName, '', (String value) {
                    return value ?? 'Name field cannot be blank.';
                  })),
              const SizedBox(
                width: 10,
              ),
              Text(
                '-',
                style: kFormHeadingStyles,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: CustomTextFormField(lastName, '', (String value) {
                  return value ?? 'Name field cannot be blank.';
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Invite',
                style: kFormHeadingStyles,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  flex: 3,
                  child: CustomTextFormField(
                      inviteList, 'Invite Participants', (value) {})),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: kprimaryColor,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            // child: RoundedButton(kprimaryColor, 'Preferences', () {}
            child: Text(
              'Preference',
              style: kFormHeadingStyles,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: buildHeader(
                  child: buildSwitch(isRecording), text: 'Recording Allowed?')),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: RoundedButton(kprimaryColor, 'Create', () {
              String meetingLink =
                  apiLink + firstName.text + '/' + lastName.text;
              print('Meeting link is $meetingLink');
              Clipboard.setData(ClipboardData(text: meetingLink)).then((_) {
                Navigator.pop(context, true);
              });
            }),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  Widget buildSwitch(value) {
    MaterialStateProperty<Color> kactiveColor =
        MaterialStateProperty.all(Colors.lightGreen);
    MaterialStateProperty<Color> kinactiveColor =
        MaterialStateProperty.all(Colors.red);
    return Transform.scale(
      scale: 1,
      child: Switch.adaptive(
        //    thumbColor: MaterialStateProperty.all(Colors.red),
        thumbColor: MaterialStateProperty.all(kprimaryColor),
        //  trackColor: MaterialStateProperty.all(kselectedColor),
        trackColor: isRecording ? kactiveColor : kinactiveColor,
        splashRadius: 30,
        value: value,
        onChanged: (value) => setState(() {
          isRecording = value;
          print(isRecording);
        }),
      ),
    );
  }

  Widget buildHeader({
    @required Widget child,
    @required String text,
  }) =>
      Row(
        //  mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: Provider.of<AppStateNotifier>(context).darkModeEnabled
                  ? kDarkModeTextStyle
                  : kPrimaryTextStyle),
          // const SizedBox(width: 8),
          Align(alignment: Alignment.topRight, child: child),
        ],
      );
}
