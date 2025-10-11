import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';

class WargaKitaInputDecoration extends InputDecoration {
  WargaKitaInputDecoration({required IconData icon, required String labelText})
    : super(
        prefixIcon: Icon(icon, color: WargaKitaColors.black.color),
        labelText: labelText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),

        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: WargaKitaColors.secondary.color),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: WargaKitaColors.secondary.color,
            width: 2,
          ),
        ),
      );
}
