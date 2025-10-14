import 'package:flutter/material.dart';
import '../widget/confirmation_dialog.dart';


class ActivityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> kegiatan;

  const ActivityDetailScreen({super.key, required this.kegiatan});

  Widget _buildHeader(BuildContext context) {
    void onJoinPressed() => showConfirmDialog(context, kegiatan);

    final Color bgColor = kegiatan["bgColor"] as Color? ?? Color(0xFF003E6A);


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            kegiatan["title"],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onJoinPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE6B35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                        color: Color(0xFFEDEDED), width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
                child: const Text("Join Kegiatan"),
              ),
              Row(
                children: [
                  const Icon(Icons.person_2_outlined,
                      color: Colors.white, size: 30),
                  const SizedBox(width: 6),
                  Text("${kegiatan["neededVolunteers"]}/25",
                      style: TextStyle(
                          color: Colors.white, fontSize: 16)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
  Widget _buildContent() {
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
            Text(kegiatan["description"]),

            const SizedBox(height: 20),
            const Text("Kebutuhan Bantuan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["requiredAid"]),

            const SizedBox(height: 20),
            const Text("Tujuan Kegiatan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["goal"]),

            const SizedBox(height: 20),
            const Text("Catatan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["notes"] ?? "-"),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Color bgColor = kegiatan["bgColor"] as Color? ?? Color(0xFF003E6A);

    return Scaffold(
      backgroundColor: bgColor,
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
            _buildHeader(context),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }
}