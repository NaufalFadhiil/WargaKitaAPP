import 'package:flutter/material.dart';

enum WargaKitaColors {
  primary("Primary", Color(0xFF003E6A)),
  secondary("Secondary", Color(0xFFFE6B35)),
  white("White", Colors.white),
  black("Black", Colors.black);

  const WargaKitaColors(this.name, this.color);

  final String name;
  final Color color;
}
