import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _recordHelper(BuildContext context, String helpId, String helperUid) async {
  if (helpId.isEmpty || helperUid.isEmpty) return;

  try {
    final helpRef = FirebaseFirestore.instance.collection('help_requests').doc(helpId);
    final userRef = FirebaseFirestore.instance.collection('users').doc(helperUid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(helpRef);

      if (!docSnapshot.exists) {
        throw Exception("Permintaan bantuan tidak ditemukan.");
      }

      final data = docSnapshot.data();
      final List<String> helpers = (data?['helpersUids'] is List)
          ? List<String>.from(data?['helpersUids'])
          : [];

      if (helpers.contains(helperUid)) {
        return;
      }

      transaction.update(helpRef, {
        'helpersUids': FieldValue.arrayUnion([helperUid]),
      });

      transaction.set(userRef, {
        'helped_requests_count': FieldValue.increment(1),
      }, SetOptions(merge: true));
    });

  } catch (e) {
    print('Error recording helper: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencatat bantuan: ${e.toString()}')),
      );
    }
  }
}

void showHelpConfirmDialog(BuildContext context, Map<String, dynamic> helpItem) {
  final String helpId = helpItem["id"] as String? ?? '';
  final String creatorUid = helpItem["creatorUid"] as String? ?? 'dummy_uid';
  final String title = helpItem["title"] as String? ?? 'Detail Peminjaman';
  final String location = helpItem["location"] as String? ?? 'Lokasi tidak tersedia';
  final String phoneNumber = helpItem["phoneNumber"] as String? ?? '';
  final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

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
                              const CircleAvatar(
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
                                _recordHelper(context, helpId, currentUid);
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