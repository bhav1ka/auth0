import 'package:flutter/material.dart';
import '../globalvariables/constants.dart';


class CustomSnackBar
{
  static void showSnackBar(String title,BuildContext context) {
    final snackbar = SnackBar(
      content: Text(
        title,
        style: ksnackbarStyle,
      ),
      backgroundColor: kSecondaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

