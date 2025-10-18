import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../style/colors/wargakita_colors.dart';

Future<void> performLogout(BuildContext context) async {
  if (!context.mounted) return;

  try {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Anda telah berhasil logout."),
          backgroundColor: WargaKitaColors.primary.color,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
            (Route<dynamic> route) => false,
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal logout. Silakan coba lagi.")),
      );
    }
  }
}

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Konfirmasi Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Batal",
              style: TextStyle(color: WargaKitaColors.primary.color),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              performLogout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WargaKitaColors.secondary.color,
              foregroundColor: WargaKitaColors.white.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}