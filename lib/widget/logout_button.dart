import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../style/colors/wargakita_colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _onLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Anda telah berhasil logout."),
          backgroundColor: WargaKitaColors.primary.color,
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal logout. Silakan coba lagi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onLogout(context),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.logout, color: WargaKitaColors.white.color, size: 24),
      ),
    );
  }
}
