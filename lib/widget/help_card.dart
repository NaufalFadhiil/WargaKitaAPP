import 'package:flutter/material.dart';

class HelpCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const HelpCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    const Color defaultBorderColor = Color(0xFFE0E0E0);
    const double thinBorderWidth = 1.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: defaultBorderColor, width: thinBorderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
