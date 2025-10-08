import 'package:flutter/material.dart';

class HelpDetailContent extends StatelessWidget {
  final Map<String, dynamic> helpItem;

  const HelpDetailContent({
    super.key,
    required this.helpItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Keperluan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(helpItem["needs"]),
            const SizedBox(height: 20),
            const Text("Deskripsi Barang",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(helpItem["description"]),
            const SizedBox(height: 20),
            const Text("Alamat",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Color(0xFFFE6B35)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    helpItem["location"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}