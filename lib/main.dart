import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:warga_kita_app/firebase_options.dart';
import 'package:warga_kita_app/screen/add_activity_screen.dart';
import 'package:warga_kita_app/screen/add_help_screen.dart';
import 'package:warga_kita_app/screen/detail_kegiatan_screen.dart';
import 'package:warga_kita_app/screen/home_screen.dart';
import 'package:warga_kita_app/screen/login_screen.dart';
import 'package:warga_kita_app/screen/register_screen.dart';
import 'package:warga_kita_app/screen/splash_screen.dart';
import 'package:warga_kita_app/style/theme/wargakita_theme.dart';
import 'package:warga_kita_app/screen/help_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail-kegiatan': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return DetailKegiatan(kegiatan: args);
        },
        '/add-activity': (context) => const AddActivityScreen(),
        '/add-help': (context) => const AddHelpScreen(),
        '/help-detail': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return HelpDetailScreen(helpItem: args);
        },
      },
    );
  }
}
