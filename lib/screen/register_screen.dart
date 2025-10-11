import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
import '../data/user_model.dart';
import '../widget/registration_form_field.dart';

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

          final userProfile = UserModel(
            uid: user.uid,
            username: _nameController.text,
            email: _emailController.text,
            phoneNumber: _phoneController.text,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(
            userProfile.toFirestore()..['created_at'] = FieldValue.serverTimestamp(),
          );

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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
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
                    'Register untuk akses Community!',
                    style: WargaKitaTextStyles.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  RegistrationFormFields(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    phoneController: _phoneController,
                    onRegister: _onRegister,
                    onLoginRedirect: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}