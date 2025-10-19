import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
import '../controller/add_activity_controller.dart';
import '../style/colors/wargakita_colors.dart';

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
                style: WargaKitaTextStyles.bodyMedium.copyWith(
                  color: WargaKitaColors.black.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isOptional)
                Text(
                  " (opsional)",
                  style: WargaKitaTextStyles.bodySmall.copyWith(
                    color: WargaKitaColors.black.color,
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

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  late final AddActivityController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddActivityController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    final success = await _controller.submitActivity(context);
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
        title: const Text("Tambah Kegiatan"),
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
            children: [
              FormInputField(
                controller: _controller.titleController,
                title: "Judul Kegiatan",
                hintText: "Contoh: Perayaan 17 Agustus Desa Sukamaju",
                validator: (value) =>
                    _controller.validateRequired(value, 'Judul kegiatan'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormInputField(
                      controller: _controller.dateController,
                      title: "Tanggal",
                      hintText: "dd/mm/yy",
                      suffixIcon: Icons.calendar_today,
                      onSuffixIconTap: () => _controller.selectDate(context),
                      validator: _controller.validateDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FormInputField(
                      controller: _controller.timeController,
                      title: "Waktu",
                      hintText: "07:00",
                      suffixIcon: Icons.access_time,
                      onSuffixIconTap: () => _controller.selectTime(context),
                      validator: _controller.validateTime,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormInputField(
                      controller: _controller.locationController,
                      title: "Lokasi Kegiatan",
                      hintText: "Contoh: Rumah Pak RT 01",
                      validator: (value) => _controller.validateRequired(
                        value,
                        'Lokasi kegiatan',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FormInputField(
                      controller: _controller.volunteersController,
                      title: "Relawan ",
                      hintText: "Contoh: 25",
                      validator: _controller.validateVolunteers,
                    ),
                  ),
                ],
              ),
              FormInputField(
                controller: _controller.descriptionController,
                title: "Deskripsi Kegiatan",
                hintText: "Jelaskan kegiatan yang ingin anda buat",
                isLarge: true,
                validator: (value) =>
                    _controller.validateRequired(value, 'Deskripsi kegiatan'),
              ),
              FormInputField(
                controller: _controller.aidController,
                title: "Kebutuhan Bantuan",
                hintText: "Contoh: Tenda, 50 kursi, Sumbangan makanan",
                isLarge: true,
                validator: (value) =>
                    _controller.validateRequired(value, 'Kebutuhan bantuan'),
              ),
              FormInputField(
                controller: _controller.goalController,
                title: "Tujuan Kegiatan",
                hintText: "Contoh: Mempererat tali silaturahmi antar warga",
                isLarge: true,
                validator: (value) =>
                    _controller.validateRequired(value, 'Tujuan kegiatan'),
              ),
              FormInputField(
                controller: _controller.whatsappController,
                title: "Link Grup WhatsApp",
                hintText: "https://chat.whatsapp.com/grup-acara-desa",
                validator: (value) =>
                    _controller.validateRequired(value, 'Link Grup WhatsApp'),
              ),
              FormInputField(
                controller: _controller.notesController,
                title: "Catatan",
                hintText: "Isi dengan informasi tambahan untuk kegiatan anda",
                isLarge: true,
                isOptional: true,
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
