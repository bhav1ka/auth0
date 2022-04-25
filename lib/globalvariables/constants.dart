import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle ksnackbarStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: GoogleFonts.nunitoSans().toString());
//const Color kprimaryColor=Color(0XFF1288FC);
const Color kprimaryColor = Color(0XFF2EB086);
const Color kdarkModeColor = Color(0xFF253341);
const Color kSecondaryColor = Color(0XFF0058FD);

TextStyle kSecondaryTextStyle = TextStyle(
    color: kprimaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    fontFamily: GoogleFonts.openSans().toString());

TextStyle kPrimaryTextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 18,
    fontFamily: GoogleFonts.openSans().toString(),
    color: Colors.black);

TextStyle kCardTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    fontFamily: GoogleFonts.openSans().toString(),
    color: Colors.white);

TextStyle kDarkModeTextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 18,
    fontFamily: GoogleFonts.openSans().toString(),
    color: Colors.white);

TextStyle kFormHeadingStyles = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  fontFamily: GoogleFonts.openSans().toString(),
  color: kprimaryColor,
);
