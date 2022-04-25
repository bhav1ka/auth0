import 'package:flutter/material.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function userFunction;
  // ignore: use_key_in_widget_constructors
  const RoundButton(this.text, this.userFunction);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        userFunction();
      },
      child: Text(
        text,
        style: kPrimaryTextStyle,
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(50),
      ),
    );
  }
}
