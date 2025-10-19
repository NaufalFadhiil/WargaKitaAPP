import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
import 'package:warga_kita_app/widget/wargakita_input_decoration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: WargaKitaColors.primary.color,
        duration: const Duration(seconds: 2),
      ),
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

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showSuccessSnackbar("Login Berhasil! Selamat datang di Komunitas.");

        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login Gagal.';
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage = 'Email atau password salah.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Format email tidak valid.';
        }

        _showAuthError(errorMessage);
      } catch (e) {
        _showAuthError("Terjadi error tak terduga.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Login untuk akses Komunitas!',
                    style: WargaKitaTextStyles.bodyMedium,
                  ),

                  const SizedBox(height: 32),

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
                      hintText: 'Masukkan email',
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password wajib diisi";
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

                  const SizedBox(height: 21),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WargaKitaColors.primary.color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Masuk',
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
                        'Belum memiliki akun? ',
                        style: WargaKitaTextStyles.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Daftar Sekarang',
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
    );
  }
}
