import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle elMessiri = GoogleFonts.elMessiri(textStyle: const TextStyle(fontSize: 18.0));

  static TextStyle get h1 => elMessiri.copyWith(fontSize: 17.0, color: Colors.white);

  static TextStyle get h2 => elMessiri.copyWith(fontSize: 17.0, color: Color(0xff212121));

  static TextStyle get h2Bold => elMessiri.copyWith(fontWeight: FontWeight.w600);

  static TextStyle get h3 => elMessiri.copyWith(fontSize: 13.0, color: Color(0xff212121));

  static TextStyle get h4 => elMessiri.copyWith(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.blue[800]);

  // static TextStyle get reportProductUnderLined => elMessiri.copyWith(
  //     fontSize: 14.0, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, color: Color(0xff2088A8));

  static TextStyle get textFieldsLabels =>
      elMessiri.copyWith(fontSize: 14.0, color: Color(0xff808080), fontWeight: FontWeight.w400);

  static TextStyle get textFieldsText => elMessiri.copyWith(fontSize: 18.0);

  static TextStyle get textFieldsHint => elMessiri.copyWith(fontSize: 14.0, color: Colors.black);

  static TextStyle get buttonLabel =>
      elMessiri.copyWith(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold);

  static TextStyle get body => elMessiri.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      );
}
