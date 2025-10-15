import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/user_service.dart';
import '../widget/activity_confirmation_dialog.dart';


class ActivityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> kegiatan;
  final UserService _userService = UserService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  ActivityDetailScreen({super.key, required this.kegiatan});

  Widget _buildNotesInfoBox(String notes) {
    if (notes.isEmpty || notes == '-') {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5D5C4), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info,
            color: Color(0xFF6D4C41),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Catatan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorInfo(BuildContext context, String uid) {
    return FutureBuilder<String>(
      future: _userService.getUsernameByUid(uid),
      builder: (context, snapshot) {
        final creatorName = snapshot.data ?? 'Memuat...';

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Penyelenggara",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    creatorName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String creatorUid = kegiatan["creatorUid"] as String? ?? 'dummy_uid';
    final bool isCreator = creatorUid == _currentUid;

    final int neededVolunteers = int.tryParse((kegiatan["neededVolunteers"] as dynamic)?.toString() ?? "0") ?? 0;

    final int currentVolunteers = (kegiatan["currentVolunteers"] as int?) ?? 0;

    final List<String> participantsUids = (kegiatan["participantsUids"] as List<dynamic>?)
        ?.map((e) => e.toString()).toList() ?? [];

    final bool hasJoined = participantsUids.contains(_currentUid);
    final bool isFull = currentVolunteers >= neededVolunteers;

    final bool isButtonDisabled = isCreator || isFull || hasJoined;

    void onJoinPressed() {
      if (isCreator) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Anda adalah pembuat kegiatan. Anda tidak bisa bergabung."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (isFull) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Relawan sudah penuh!"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (hasJoined) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Anda sudah bergabung di kegiatan ini."),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        showActivityConfirmDialog(context, kegiatan);
      }
    }

    final String buttonText = isCreator
        ? "Anda Adalah Pembuat"
        : isFull
        ? "Relawan Penuh"
        : hasJoined
        ? "Sudah Bergabung"
        : "Join Kegiatan";

    final Color bgColor = kegiatan["bgColor"] as Color? ?? const Color(0xFF003E6A);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            kegiatan["title"] as String? ?? 'Detail Kegiatan',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: isButtonDisabled ? null : onJoinPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonDisabled
                      ? Colors.grey
                      : const Color(0xFFFE6B35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                        color: Color(0xFFEDEDED), width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),              Row(
                children: [
                  const Icon(Icons.person_2_outlined,
                      color: Colors.white, size: 30),
                  const SizedBox(width: 6),
                  Text("$currentVolunteers/$neededVolunteers",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget _buildDetailInfo({
      required IconData icon,
      required String text,
      required Color iconColor,
    }) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    final String creatorUid = kegiatan["creatorUid"] as String? ?? 'dummy_uid';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildDetailInfo(
                    icon: Icons.location_on,
                    text: kegiatan["location"] as String? ?? 'Lokasi tidak tersedia',
                    iconColor: const Color(0xFFFE6B35),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDetailInfo(
                    icon: Icons.access_time,
                    text: kegiatan["time"] as String? ?? 'Belum ada waktu',
                    iconColor: const Color(0xFFFE6B35),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDetailInfo(
                    icon: Icons.calendar_today,
                    text: kegiatan["date"] as String? ?? '-',
                    iconColor: const Color(0xFFFE6B35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildCreatorInfo(context, creatorUid),

            const Text("Deskripsi",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["description"] as String? ?? 'Deskripsi tidak tersedia.'),

            const SizedBox(height: 20),
            const Text("Kebutuhan Bantuan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["requiredAid"] as String? ?? 'Kebutuhan bantuan tidak dicantumkan.'),

            const SizedBox(height: 20),
            const Text("Tujuan Kegiatan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["goal"] as String? ?? 'Tujuan kegiatan tidak dicantumkan.'),

            const SizedBox(height: 20),
            _buildNotesInfoBox(kegiatan["notes"] as String? ?? ''),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Color bgColor = kegiatan["bgColor"] as Color? ?? const Color(0xFF003E6A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Detail Kegiatan",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }
}