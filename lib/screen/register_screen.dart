import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
import 'package:warga_kita_app/widget/wargakita_input_decoration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: WargaKitaColors.primary.color,
                  size: 60,
                ),
                const SizedBox(height: 12),
                Text(
                  "Registrasi Berhasil!",
                  style: WargaKitaTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: WargaKitaColors.primary.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Akun Anda telah berhasil dibuat.",
                  textAlign: TextAlign.center,
                  style: WargaKitaTextStyles.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  "Silakan login dengan akun yang sudah anda buat.",
                  textAlign: TextAlign.center,
                  style: WargaKitaTextStyles.bodyMedium,
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WargaKitaColors.primary.color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Login Sekarang",
                    style: WargaKitaTextStyles.bodyMedium.copyWith(
                      color: WargaKitaColors.white.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAuthError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: WargaKitaColors.secondary.color,
      ),
    );
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final user = userCredential.user;

        if (user != null) {
          await user.updateDisplayName(_nameController.text);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'username': _nameController.text,
            'email': _emailController.text,
            'phone_number': _phoneController.text,
            'created_at': FieldValue.serverTimestamp(),

            'created_activities_count': 0,
            'joined_activities_count': 0,
            'created_help_requests_count': 0,
            'helped_requests_count': 0,
          });

          _showSuccessDialog();
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registrasi Gagal.';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Kata sandi terlalu lemah.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Format email tidak valid.';
        } else {
          errorMessage = 'Error Auth: ${e.message}';
        }
        _showAuthError(errorMessage);
      } catch (e) {
        String errorMessage = 'Terjadi error tak terduga: ${e.toString()}';
        _showAuthError(errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: WargaKitaColors.white.color,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 45.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/logo+name.png', height: 40),
                        Icon(
                          Icons.info_outline,
                          color: WargaKitaColors.black.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    Text(
                      'Selamat Datang!',
                      style: WargaKitaTextStyles.headlineLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Register untuk akses Komunitas!',
                      style: WargaKitaTextStyles.bodyMedium,
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? "Nama wajib diisi"
                          : null,
                      decoration: WargaKitaInputDecoration(
                        icon: Icons.person,
                        labelText: 'Nama',
                        hintText: 'Nama Lengkap Anda',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
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
                        hintText: '@gmail.com',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
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
                        labelText: 'Masukkan Password',
                        hintText: 'Minimal 6 Karakter',

                        suffixIcon: _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixIconTap: _togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty
                          ? "Nomor telepon wajib diisi"
                          : null,
                      decoration: WargaKitaInputDecoration(
                        icon: Icons.phone,
                        labelText: 'Nomor Telepon',
                        hintText: '62xxxxxxxxx',
                      ),
                    ),
                    const SizedBox(height: 21),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onRegister,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah memiliki akun? ',
                          style: WargaKitaTextStyles.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            'Login Sekarang',
                            style: WargaKitaTextStyles.bodyMedium.copyWith(
                              color: WargaKitaColors.primary.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}