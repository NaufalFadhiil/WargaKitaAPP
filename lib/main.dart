import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:warga_kita_app/firebase_options.dart';
import 'package:warga_kita_app/screen/add_activity_screen.dart';
import 'package:warga_kita_app/screen/add_help_screen.dart';
import 'package:warga_kita_app/screen/activity_detail_screen.dart';
import 'package:warga_kita_app/screen/home_screen.dart';
import 'package:warga_kita_app/screen/login_screen.dart';
import 'package:warga_kita_app/screen/onboarding_screen.dart';
import 'package:warga_kita_app/screen/profile_screen.dart';
import 'package:warga_kita_app/screen/register_screen.dart';
import 'package:warga_kita_app/screen/splash_screen.dart';
import 'package:warga_kita_app/style/theme/wargakita_theme.dart';
import 'package:warga_kita_app/screen/help_detail_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'provider/activity_provider.dart';
import 'provider/help_request_provider.dart';
import 'provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => HelpRequestProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WargaKita App',
        theme: WargakitaTheme.mainTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/start': (context) => const GetStartedApp(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/detail-acara': (context) {
            final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ActivityDetailScreen(acara: args);
          },
          '/add-activity': (context) => const AddActivityScreen(),
          '/add-help': (context) => const AddHelpScreen(),
          '/help-detail': (context) {
            final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return HelpDetailScreen(helpItem: args);
          },
        },
      ),
    );
  }
}