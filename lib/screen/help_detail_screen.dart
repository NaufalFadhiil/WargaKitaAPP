import 'package:flutter/material.dart';
import '../widget/detail_minjam_header.dart';
import '../widget/help_detail_content.dart';

class HelpDetailScreen extends StatelessWidget {
  final Map<String, dynamic> helpItem;

  const HelpDetailScreen({super.key, required this.helpItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003E6A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Detail Bantu",
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
            HelpDetailHeader(helpItem: helpItem),
            Expanded(
              child: HelpDetailContent(helpItem: helpItem),
            ),
          ],
        ),
      ),
    );
  }
}