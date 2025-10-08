import 'package:flutter/material.dart';
import '../widget/form_input_field.dart';
import '../style/colors/wargakita_colors.dart';

class AddActivityScreen extends StatelessWidget {
  const AddActivityScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kegiatan"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const FormInputField(
              title: "Judul Kegiatan",
              hintText: "Contoh: Perayaan 17 Agustus Desa Sukamaju",
            ),

            Row(
              children: const [
                Expanded(
                  child: FormInputField(
                    title: "Tanggal",
                    hintText: "hari/bulan/tahun",
                    suffixIcon: Icons.calendar_today,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormInputField(
                    title: "Waktu",
                    hintText: "--,--",
                    suffixIcon: Icons.access_time,
                  ),
                ),
              ],
            ),

            Row(
              children: const [
                Expanded(
                  child: FormInputField(
                    title: "Lokasi Kegiatan",
                    hintText: "Contoh: Rumah Pak RT 01",
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormInputField(
                    title: "Relawan Dibutuhkan",
                    hintText: "Contoh: 25",
                  ),
                ),
              ],
            ),

            const FormInputField(
              title: "Deskripsi Kegiatan",
              hintText: "Jelaskan kegiatan yang ingin anda buat",
              isLarge: true,
            ),

            const FormInputField(
              title: "Kebutuhan Bantuan",
              hintText: "Contoh: Tenda, 50 kursi, Sumbangan makanan",
              isLarge: true,
            ),

            const FormInputField(
              title: "Tujuan Kegiatan",
              hintText: "Contoh: Mempererat tali silaturahmi antar warga",
              isLarge: true,
            ),

            const FormInputField(
              title: "Link Grup WhatsApp",
              hintText: "https://chat.whatsapp.com/grup-acara-desa",
            ),

            const FormInputField(
              title: "Catatan",
              hintText: "Isi dengan informasi tambahan untuk kegiatan anda",
              isLarge: true,
              isOptional: true,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logika untuk menyimpan data kegiatan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Tambahkan",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: WargaKitaColors.white.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
