import 'package:flutter/material.dart';
import '../data/help_model.dart';
import '../service/add_help_service.dart';
import '../style/colors/wargakita_colors.dart';

class AddHelpController {
  final AddHelpService _helpService = AddHelpService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _purposeController = TextEditingController();
  final _itemDescriptionController = TextEditingController();

  TextEditingController get titleController => _titleController;
  TextEditingController get locationController => _locationController;
  TextEditingController get purposeController => _purposeController;
  TextEditingController get itemDescriptionController => _itemDescriptionController;

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName wajib diisi.';
    }
    return null;
  }

  Future<bool> submitHelpRequest(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final helpRequest = HelpData(
        title: _titleController.text,
        location: _locationController.text,
        purpose: _purposeController.text,
        itemDescription: _itemDescriptionController.text,
      );

      try {
        await _helpService.addHelpRequest(helpRequest);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Permintaan peminjaman berhasil ditambahkan!',
                style: TextStyle(color: WargaKitaColors.white.color),
              ),
              backgroundColor: WargaKitaColors.primary.color,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambahkan permintaan peminjaman: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    }
    return false;
  }

  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _purposeController.dispose();
    _itemDescriptionController.dispose();
  }
}