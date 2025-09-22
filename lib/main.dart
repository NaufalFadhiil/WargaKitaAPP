import 'package:flutter/material.dart';
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WargaKita Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text pakai style dari theme
            Text(
              "Judul dengan HeadlineLarge",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              "Ini bodyMedium dengan warna hitam",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            // Tombol Primary (biru)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {},
              child: const Text("Tombol Primary (Biru)"),
            ),

            const SizedBox(height: 12),

            // Tombol Secondary (oranye)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              onPressed: () {},
              child: const Text("Tombol Secondary (Oranye)"),
            ),
          ],
        ),
      ),
    );
  }
}
