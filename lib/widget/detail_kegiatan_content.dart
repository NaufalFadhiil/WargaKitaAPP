import 'package:flutter/material.dart';

class DetailKegiatanContent extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  const DetailKegiatanContent({
    super.key,
    required this.kegiatan,
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
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFFFE6B35)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          kegiatan["location"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFFFE6B35)),
                    const SizedBox(width: 6),
                    Text(kegiatan["date"]),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("Deskripsi",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["subtitle"]),

            const SizedBox(height: 20),
            const Text("Kebutuhan Bantuan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text("lorem ipsum dolor sit amet"),
            const SizedBox(height: 20),
            const Text("Tujuan Kegiatan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text("lorem ipsum dolor sit amet"),
            const SizedBox(height: 20),
            const Text("Catatan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text("lorem ipsum dolor sit amet"),
          ],
        ),
      ),
    );
  }
}