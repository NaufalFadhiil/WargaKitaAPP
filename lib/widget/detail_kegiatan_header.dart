import 'package:flutter/material.dart';

class DetailKegiatanHeader extends StatelessWidget {
  final Map<String, dynamic> kegiatan;
  final VoidCallback onJoinPressed;

  const DetailKegiatanHeader({
    super.key,
    required this.kegiatan,
    required this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                  const Text("6/25",
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
}