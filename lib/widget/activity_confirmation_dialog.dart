import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/user_service.dart';
import '../style/colors/wargakita_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

void _launchWhatsApp(BuildContext context, String whatsappLink) async {
  if (whatsappLink.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link WhatsApp tidak tersedia untuk kegiatan ini."), backgroundColor: Colors.orange),
      );
    }
    return;
  }

  final Uri uri = Uri.parse(whatsappLink);

  if (!await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuka link WhatsApp. Pastikan aplikasi terinstal."), backgroundColor: Colors.red),
      );
    }
  }
}

Future<void> _increaseVolunteerCount(BuildContext context, String activityId, String whatsappLink) async {
  final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
  if (activityId.isEmpty || currentUid == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mendapatkan ID pengguna/kegiatan. Gagal bergabung."), backgroundColor: Colors.red),
      );
    }
    return;
  }

  try {
    final activityRef = FirebaseFirestore.instance.collection('activities').doc(activityId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(activityRef);

      if (!docSnapshot.exists) {
        throw Exception("Kegiatan tidak ditemukan.");
      }

      final data = docSnapshot.data();
      final currentVolunteers = data?['currentVolunteers'] as int? ?? 0;
      final neededVolunteers = data?['neededVolunteers'] as int? ?? 0;
      final List<String> participants = (data?['participantsUids'] is List)
          ? List<String>.from(data?['participantsUids'])
          : [];

      if (currentVolunteers >= neededVolunteers) {
        throw Exception("Maaf, relawan sudah penuh!");
      }

      if (participants.contains(currentUid)) {
        throw Exception("Anda sudah terdaftar di kegiatan ini!");
      }

      transaction.update(activityRef, {
        'currentVolunteers': FieldValue.increment(1),
        'participantsUids': FieldValue.arrayUnion([currentUid]),
      });
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda berhasil bergabung! Membuka grup WhatsApp..."), backgroundColor: Colors.green),
      );

    }

    _launchWhatsApp(context, whatsappLink);

  } catch (e) {
    String errorMessage = 'Gagal bergabung.';

    if (e.toString().contains("relawan sudah penuh")) {
      errorMessage = "Relawan sudah penuh!";
    } else if (e.toString().contains("sudah terdaftar")) {
      errorMessage = "Anda sudah terdaftar di kegiatan ini!";
    } else {
      print('Error updating volunteer count: $e');
      errorMessage = 'Gagal bergabung: Terjadi error saat update data.';
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }
}


void showActivityConfirmDialog(BuildContext context, Map<String, dynamic> activity) {
  final String creatorUid = activity["creatorUid"] as String? ?? 'dummy_uid';
  final String title = activity["title"] as String? ?? 'Detail Kegiatan';
  final String location = activity["location"] as String? ?? 'Lokasi tidak tersedia';
  final String time = activity["time"] as String? ?? 'Waktu tidak tersedia';
  final String date = activity["date"] as String? ?? 'Tanggal tidak tersedia';
  final String whatsappLink = activity["whatsappLink"] as String? ?? '';
  final String activityId = activity["id"] as String? ?? '';

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Konfirmasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFEDEDED), height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20),
              child: FutureBuilder<Map<String, String>>(
                  future: UserService().getUserData(creatorUid),
                  builder: (context, snapshot) {
                    final creatorName = snapshot.data?['username'] ?? 'Memuat...';

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Detail Kegiatan", style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF003E6A))),
                        const SizedBox(height: 15),

                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 15),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFFE6B35), size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(location, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Color(0xFF003E6A), size: 16),
                                        const SizedBox(width: 4),
                                        Text("$time WIB", style: const TextStyle(fontSize: 14)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Color(0xFFFE6B35), size: 24),
                            const SizedBox(width: 12),
                            Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage("assets/images/profile1.jpeg"),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  creatorName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const Text(
                                  "Penyelenggara",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                            "Komitmen ini sebagai tanda kesediaan saya untuk hadir dan membantu.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _increaseVolunteerCount(context, activityId, whatsappLink);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WargaKitaColors.primary.color,
                              foregroundColor: WargaKitaColors.white.color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text(
                              "Ikut Partisipasi",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              ),
            )
          ],
        ),
      );
    },
  );
}