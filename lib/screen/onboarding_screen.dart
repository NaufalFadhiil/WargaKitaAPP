import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';

class GetStartedApp extends StatelessWidget {
  const GetStartedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-Onboarding1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: WargaKitaTextStyles.headlineLarge,
                  children: [
                    TextSpan(text: "Bangun ", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: "Komunitas",
                      style: TextStyle(color: WargaKitaColors.secondary.color, fontSize: 27, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "\nKuatkan Kebersamaan!", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox.square(dimension: 20,),
              Text(
                'Akses informasi acara kapan saja,\nberikan bantuan dan dukungan\njadikan hidup lebih ringan bersama komunitas.',
                textAlign: TextAlign.center,
                style: WargaKitaTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox.square(dimension: 145,),
              Text(
                '📢 Berita Warga • 🏘️ Komunitas Lokal • 🙌 Aksi Sosial',
                textAlign: TextAlign.center,
                style: WargaKitaTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox.square(dimension: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFF003E6A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.explore,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Eksplor Sekarang',
                      style: WargaKitaTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox.square(dimension: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
