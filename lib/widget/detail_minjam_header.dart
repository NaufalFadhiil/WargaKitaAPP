import 'package:flutter/material.dart';
import '../widget/help_confirmation_dialog.dart';

class HelpDetailHeader extends StatelessWidget {
  final Map<String, dynamic> helpItem;

  const HelpDetailHeader({
    super.key,
    required this.helpItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Text(
            helpItem["title"],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: () => showHelpConfirmDialog(context, helpItem),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFE6B35),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFEDEDED), width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Bantu"),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}