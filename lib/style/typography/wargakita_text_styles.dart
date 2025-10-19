import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';

class WargaKitaTextStyles {
  static const TextStyle _commonStyle = TextStyle(
    fontFamily: 'Montserrat',
    color: Colors.black,
  );

  static TextStyle headlineLarge = _commonStyle.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: WargaKitaColors.primary.color,
  );

  static TextStyle bodyMedium = _commonStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle bodySmall = _commonStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}
