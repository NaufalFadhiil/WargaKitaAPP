import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String userName;
  final String date;
  final String profileAsset;
  final Widget? logoutButton; 

  const HeaderSection({
    super.key,
    required this.userName,
    required this.date,
    required this.profileAsset,
    this.logoutButton, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF003366),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Hello, $userName",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              if (logoutButton != null) logoutButton!,

              CircleAvatar(
                backgroundImage: AssetImage(profileAsset),
                radius: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "📅 $date",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          const Text.rich(
            TextSpan(
              text: "Explore Your\n ",
              style: TextStyle(color: Colors.white, fontSize: 20),
              children: [
                TextSpan(
                  text: "Community",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                  text: ", Today!",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
