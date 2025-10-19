import 'package:flutter/material.dart';
import '../data/activity_model.dart';
import '../service/add_activity_service.dart';
import '../style/colors/wargakita_colors.dart';

class AddActivityController {
  final AddActivityService _activityService = AddActivityService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _volunteersController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _aidController = TextEditingController();
  final _goalController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _notesController = TextEditingController();

  TextEditingController get titleController => _titleController;
  TextEditingController get dateController => _dateController;
  TextEditingController get timeController => _timeController;
  TextEditingController get locationController => _locationController;
  TextEditingController get volunteersController => _volunteersController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get aidController => _aidController;
  TextEditingController get goalController => _goalController;
  TextEditingController get whatsappController => _whatsappController;
  TextEditingController get notesController => _notesController;

  final _dateRegex = RegExp(r"^\d{2}/\d{2}/\d{2}$");
  final _timeRegex = RegExp(r"^\d{2}:\d{2}$");

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null) {
      final String formattedDate =
          '${pickedDate.day.toString().padLeft(2, '0')}/'
          '${pickedDate.month.toString().padLeft(2, '0')}/'
          '${pickedDate.year.toString().substring(2)}';
      _dateController.text = formattedDate;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:'
          '${pickedTime.minute.toString().padLeft(2, '0')}';
      _timeController.text = formattedTime;
    }
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Wajib diisi.';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (validateRequired(value, 'Tanggal') != null) return validateRequired(value, 'Tanggal');
    if (!_dateRegex.hasMatch(value!)) {
      return 'Format harus dd/mm/yy.';
    }
    return null;
  }

  String? validateTime(String? value) {
    if (validateRequired(value, 'Waktu') != null) return validateRequired(value, 'Waktu');
    if (!_timeRegex.hasMatch(value!)) {
      return 'Format harus 07:00.';
    }
    return null;
  }

  String? validateVolunteers(String? value) {
    if (validateRequired(value, 'Jumlah relawan') != null) return validateRequired(value, 'Jumlah relawan');
    if (int.tryParse(value!.replaceAll(RegExp(r'\D'), '')) == null) {
      return 'Hanya boleh angka.';
    }
    return null;
  }

  Future<bool> submitActivity(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final activity = ActivityModel(
        title: _titleController.text,
        date: _dateController.text,
        time: _timeController.text,
        location: _locationController.text,
        neededVolunteers: _volunteersController.text.replaceAll(RegExp(r'\D'), ''),
        description: _descriptionController.text,
        requiredAid: _aidController.text,
        goal: _goalController.text,
        whatsappLink: _whatsappController.text,
        notes: _notesController.text,
      );

      try {
        await _activityService.addActivity(activity);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Acara berhasil ditambahkan!', style: TextStyle(color: WargaKitaColors.white.color)),
              backgroundColor: WargaKitaColors.primary.color,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan acara: $e')),
          );
        }
        return false;
      }
    }
    return false;
  }

  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _volunteersController.dispose();
    _descriptionController.dispose();
    _aidController.dispose();
    _goalController.dispose();
    _whatsappController.dispose();
    _notesController.dispose();
  }
}