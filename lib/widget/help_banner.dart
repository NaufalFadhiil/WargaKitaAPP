import 'package:flutter/material.dart';

class HelpBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const HelpBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: isChecked,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          decoration:
          isChecked ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}