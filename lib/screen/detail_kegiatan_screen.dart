import 'package:flutter/material.dart';
import '../widget/detail_kegiatan_header.dart';
import '../widget/detail_kegiatan_content.dart';
import '../widget/confirmation_dialog.dart';

class DetailKegiatan extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  const DetailKegiatan({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kegiatan["bgColor"],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Detail Kegiatan",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailKegiatanHeader(
              kegiatan: kegiatan,
              onJoinPressed: () => showConfirmDialog(context, kegiatan),
            ),
            Expanded(
              child: DetailKegiatanContent(kegiatan: kegiatan),
            ),
          ],
        ),
      ),
    );
  }
}