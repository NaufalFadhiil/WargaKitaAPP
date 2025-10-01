import 'package:flutter/material.dart';
import 'package:warga_kita_app/screen/add_activity_screen.dart';
import 'package:warga_kita_app/screen/add_help_screen.dart';
import 'package:warga_kita_app/screen/home_screen.dart';
import 'package:warga_kita_app/screen/detail_kegiatan.dart';
import 'package:warga_kita_app/screen/login_screen.dart';
import 'package:warga_kita_app/screen/register_screen.dart';
import 'package:warga_kita_app/screen/splash_screen.dart';
import 'package:warga_kita_app/style/theme/wargakita_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WargaKita App',
      theme: WargakitaTheme.mainTheme,

      // nama route untuk navigasi
      initialRoute: '/',

      // daftar route
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/detail-kegiatan': (context) => DetailKegiatan()
        '/add-activity': (context) => const AddActivityScreen(),
        '/add-help': (context) => const AddHelpScreen(),
    //  '/activity-detail': (context) => const ActivityDetailScreen(),
    //  '/help-detail': (context) => const HelpDetailScreen(),

      },
    );
  }
}
