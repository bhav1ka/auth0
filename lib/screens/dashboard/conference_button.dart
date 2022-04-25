import 'package:flutter/material.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';

class ConferenceButton extends StatelessWidget {
  final String text;
  final Function userFunction;
  // ignore: use_key_in_widget_constructors
  const ConferenceButton(this.text, this.userFunction);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        onPressed: () => userFunction,
        child: Text(
          text,
          style: ksnackbarStyle,
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: Colors.grey))),
          elevation: MaterialStateProperty.all(5),
          padding: MaterialStateProperty.all(const EdgeInsets.all(18)),
        ),
      ),
    );
  }
}
