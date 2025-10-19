  import 'package:flutter/material.dart';
import '../style/colors/wargakita_colors.dart';
import '../controller/add_help_controller.dart';

class FormInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool isLarge;
  final IconData? suffixIcon;
  final bool isOptional;
  final TextEditingController? controller;
  final VoidCallback? onSuffixIconTap;
  final FormFieldValidator<String>? validator;

  const FormInputField({
    super.key,
    required this.title,
    required this.hintText,
    this.isLarge = false,
    this.suffixIcon,
    this.isOptional = false,
    this.controller,
    this.onSuffixIconTap,
    this.validator,
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isOptional)
                Text(
                  " (opsional)",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: isLarge ? 5 : 1,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
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
                borderSide: BorderSide(
                  color: WargaKitaColors.primary.color,
                  width: 2,
                ),
              ),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon, color: theme.primaryColor),
                      onPressed: onSuffixIconTap,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class AddHelpScreen extends StatefulWidget {
  const AddHelpScreen({super.key});

  @override
  State<AddHelpScreen> createState() => _AddHelpScreenState();
}

class _AddHelpScreenState extends State<AddHelpScreen> {
  late final AddHelpController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddHelpController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    final success = await _controller.submitHelpRequest(context);
    if (success) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Peminjaman"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormInputField(
                controller: _controller.titleController,
                title: "Judul Peminjaman",
                hintText: "Contoh: Pinjam Sound System",
                validator: (value) =>
                    _controller.validateRequired(value, 'Judul peminjaman'),
              ),
              FormInputField(
                controller: _controller.locationController,
                title: "Titik Bertemu/Lokasi Acara",
                hintText: "Contoh: Rumah Pak RT 01",
                validator: (value) =>
                    _controller.validateRequired(value, 'Titik bertemu'),
              ),
              FormInputField(
                controller: _controller.purposeController,
                title: "Keperluan (Tujuan Peminjaman)",
                hintText: "Tujuan peminjaman",
                isLarge: true,
                validator: (value) =>
                    _controller.validateRequired(value, 'Keperluan'),
              ),
              FormInputField(
                controller: _controller.itemDescriptionController,
                title: "Deskripsi Barang",
                hintText: "Jelaskan barang yang ingin Anda pinjam",
                isLarge: true,
                validator: (value) =>
                    _controller.validateRequired(value, 'Deskripsi barang'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Tambahkan",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: WargaKitaColors.white.color,
                      fontWeight: FontWeight.bold,
                    ),
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
