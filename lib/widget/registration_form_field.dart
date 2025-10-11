import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
import 'package:warga_kita_app/widget/wargakita_input_decoration.dart';

class RegistrationFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final VoidCallback onRegister;
  final VoidCallback onLoginRedirect;

  const RegistrationFormFields({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.onRegister,
    required this.onLoginRedirect,
  });

  Widget _buildLoginRedirectText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah memiliki akun? ',
          style: WargaKitaTextStyles.bodyMedium,
        ),
        GestureDetector(
          onTap: onLoginRedirect,
          child: Text(
            'Login Sekarang',
            style: WargaKitaTextStyles.bodyMedium.copyWith(
              color: WargaKitaColors.primary.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            validator: (value) =>
            value == null || value.isEmpty ? "Nama wajib diisi" : null,
            decoration: WargaKitaInputDecoration(
              icon: Icons.person,
              labelText: 'Nama',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email wajib diisi";
              } else if (!value.endsWith('@gmail.com')) {
                return "Email harus menggunakan format @gmail.com";
              }
              return null;
            },
            decoration: WargaKitaInputDecoration(
              icon: Icons.email,
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password wajib diisi";
              } else if (value.length < 6) {
                return "Password minimal 6 karakter";
              }
              return null;
            },
            decoration: WargaKitaInputDecoration(
              icon: Icons.lock,
              labelText: 'Masukkan password',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) => value == null || value.isEmpty
                ? "Nomor telepon wajib diisi"
                : null,
            decoration: WargaKitaInputDecoration(
              icon: Icons.phone,
              labelText: 'Nomor Telepon',
            ),
          ),

          const SizedBox(height: 21),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: WargaKitaColors.primary.color,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Buat Akun',
                style: WargaKitaTextStyles.bodyMedium.copyWith(
                  color: WargaKitaColors.white.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),
          _buildLoginRedirectText(),
        ],
      ),
    );
  }
}