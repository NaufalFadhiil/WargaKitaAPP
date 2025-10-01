import 'package:flutter/material.dart';
import '../widget/form_input_field.dart';
import '../style/colors/wargakita_colors.dart';

class AddHelpScreen extends StatelessWidget {
  const AddHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Peminjaman"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const FormInputField(
              title: "Judul Peminjaman",
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

            const FormInputField(
              title: "Lokasi Kegiatan",
              hintText: "Contoh: Rumah Pak RT 01",
            ),

            const FormInputField(
              title: "Keperluan",
              hintText: "Tujuan peminjaman",
              isLarge: true,
            ),

            const FormInputField(
              title: "Deskripsi Barang",
              hintText: "Jelaskan barang yang ingin Anda pinjam",
              isLarge: true,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logika untuk menyimpan data peminjaman/bantuan
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
