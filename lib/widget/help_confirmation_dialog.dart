import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/user_service.dart';

void showHelpConfirmDialog(BuildContext context, Map<String, dynamic> helpItem) {
  final String creatorUid = helpItem["creatorUid"] as String? ?? 'dummy_uid';
  final String title = helpItem["title"] as String? ?? 'Detail Peminjaman';
  final String location = helpItem["location"] as String? ?? 'Lokasi tidak tersedia';  final String phoneNumber = helpItem["phoneNumber"] as String? ?? '';

  void launchWhatsApp() async {
    if (phoneNumber.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuka WhatsApp. Nomor telepon peminjam tidak tersedia.")),
        );
      }
      return;
    }

    final String whatsappUrl = "https://wa.me/$phoneNumber";
    final Uri uri = Uri.parse(whatsappUrl);

    if (!await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuka aplikasi WhatsApp. Pastikan aplikasi terinstal.")),
        );
      }
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<Map<String, String>>(
            future: UserService().getUserData(creatorUid),
            builder: (context, snapshot) {
              final creatorName = snapshot.data?['username'] ?? 'Memuat...';

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Konfirmasi Bantuan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 4, color: Color(0xFFEDEDED)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Detail Peminjaman", style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003E6A))),
                          const SizedBox(height: 8),

                          Text(
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 15),

                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xFFFE6B35), size: 25),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage("assets/images/profile1.jpeg"),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      creatorName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  const Text(
                                      "Peminjam",
                                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                              "Komitmen ini sebagai tanda kesediaan saya untuk menghubungi peminjam dan menawarkan bantuan.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                launchWhatsApp();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003E6A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: const Text(
                                "Saya Bisa Membantu",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
        ),
      );
    },
  );
}