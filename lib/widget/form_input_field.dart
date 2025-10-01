import 'package:flutter/material.dart';
import '../style/colors/wargakita_colors.dart';

class FormInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool isLarge;
  final IconData? suffixIcon;
  final bool isOptional;

  const FormInputField({
    super.key,
    required this.title,
    required this.hintText,
    this.isLarge = false,
    this.suffixIcon,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (isOptional)
                Text(
                  " (opsional)",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: isLarge ? 5 : 1,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: WargaKitaColors.primary.color),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: WargaKitaColors.primary.color),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: WargaKitaColors.primary.color, width: 2),
              ),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: theme.primaryColor) : null,
            ),
          ),
        ],
      ),
    );
  }
}
