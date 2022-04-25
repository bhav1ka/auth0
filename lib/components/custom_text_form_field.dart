import 'package:flutter/material.dart';
import 'package:mpsc_demo/globalvariables/constants.dart';
import 'package:provider/provider.dart';
import '../utils/app_state_notifier.dart';

class CustomTextFormField extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomTextFormField(
      this.textController, this.hintText, this.validateText);
  final TextEditingController textController;
  final String hintText;
  final Function validateText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Provider.of<AppStateNotifier>(context).darkModeEnabled
          ? kDarkModeTextStyle
          : kPrimaryTextStyle,
      validator: (value) {
        return validateText(value);
      },
      controller: textController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Provider.of<AppStateNotifier>(context).darkModeEnabled
            ? kDarkModeTextStyle
            : kPrimaryTextStyle,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: kprimaryColor,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Provider.of<AppStateNotifier>(context).darkModeEnabled
                ? Colors.white
                : Colors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
