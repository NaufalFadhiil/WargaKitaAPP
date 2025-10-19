import 'package:flutter/material.dart';
import '../style/colors/wargakita_colors.dart';
import '../style/typography/wargakita_text_styles.dart';

class OtpWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSuccess;

  const OtpWidget({
    super.key,
    required this.controller,
    required this.onSuccess,
  });

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final int otpLength = 6;
  late List<TextEditingController> _controllers;
  bool isOtpInvalid = false;

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
                  "Verifikasi OTP Berhasil!",
                  style: WargaKitaTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: WargaKitaColors.primary.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "OTP Anda telah berhasil diverifikasi.",
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Login",
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

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (_) => TextEditingController());
  }

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();
    widget.controller.text = otp;

    if (otp == "123456") {
      setState(() {
        isOtpInvalid = false;
      });
      Navigator.of(context).pop();
      _showSuccessDialog();
    } else {
      setState(() {
        isOtpInvalid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: WargaKitaColors.white.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: WargaKitaColors.secondary.color,
                    size: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Kembali",
                    style: WargaKitaTextStyles.bodyMedium.copyWith(
                      color: WargaKitaColors.secondary.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Center(
            child: Text(
              "Verifikasi OTP",
              style: WargaKitaTextStyles.headlineLarge.copyWith(fontSize: 22),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Masukkan kode OTP yang telah dikirim ke nomor Anda",
              style: WargaKitaTextStyles.bodyMedium.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(otpLength, (index) {
                return SizedBox(
                  width: 44,
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: WargaKitaTextStyles.headlineLarge.copyWith(
                      fontSize: 17,
                      color: isOtpInvalid
                          ? WargaKitaColors.secondary.color
                          : WargaKitaColors.primary.color,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isOtpInvalid
                              ? WargaKitaColors.secondary.color
                              : WargaKitaColors.primary.color.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isOtpInvalid
                              ? WargaKitaColors.secondary.color
                              : WargaKitaColors.primary.color,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (isOtpInvalid) {
                        setState(() {
                          isOtpInvalid = false;
                        });
                      }
                      if (value.isNotEmpty && index < otpLength - 1) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),

            if (isOtpInvalid) ...[
              const SizedBox(height: 8),
              Text(
                "OTP salah ❌",
                style: WargaKitaTextStyles.bodyMedium.copyWith(
                  color: WargaKitaColors.secondary.color,
                ),
              ),
            ],

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: WargaKitaColors.primary.color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Verifikasi",
                  style: WargaKitaTextStyles.bodyMedium.copyWith(
                    color: WargaKitaColors.white.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
