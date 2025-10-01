import 'package:flutter/material.dart';
import '../style/colors/wargakita_colors.dart';

class AddSelectionModal extends StatelessWidget {
  const AddSelectionModal({super.key});

  Widget _buildSelectionButton(BuildContext context, String title, String routeName) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          onPressed: () {
            Navigator.pop(context);

            Navigator.pushNamed(context, routeName);
          },
          child: Text(
            title,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: WargaKitaColors.white.color,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Pilih",
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),

              _buildSelectionButton(context, "Acara", '/add-activity'),
              _buildSelectionButton(context, "Bantu", '/add-help'),

              // Tombol Batal
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Batal",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddSelectionModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddSelectionModal();
    },
  );
}
