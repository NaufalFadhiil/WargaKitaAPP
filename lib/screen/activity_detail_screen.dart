import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warga_kita_app/service/delete_activity_service.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';

import '../service/user_service.dart';
import '../widget/activity_confirmation_dialog.dart';
import '../widget/delete_confirmation_dialog.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> acara;
  final UserService _userService = UserService();
  final DeleteActivityService _deleteService = DeleteActivityService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  ActivityDetailScreen({super.key, required this.acara});

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
          const Icon(Icons.info, color: Color(0xFF6D4C41), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Catatan",
                  style: WargaKitaTextStyles.bodyMedium.copyWith(
                    color: WargaKitaColors.black.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notes,
                  style: WargaKitaTextStyles.bodyMedium.copyWith(
                    color: WargaKitaColors.black.color,
                    fontSize: 14,
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
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Penyelenggara:",
                    style: WargaKitaTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: WargaKitaColors.secondary.color,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    creatorName,
                    style: WargaKitaTextStyles.bodyMedium.copyWith(
                      color: WargaKitaColors.black.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 2, height: 15, color: Color(0xFFEDEDED)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String creatorUid = acara["creatorUid"] as String? ?? 'dummy_uid';
    final String activityId = acara["id"] as String? ?? '';
    final bool isCreator = creatorUid == _currentUid;

    final int neededVolunteers =
        int.tryParse(
          (acara["neededVolunteers"] as dynamic)?.toString() ?? "0",
        ) ??
            0;

    final int currentVolunteers = (acara["currentVolunteers"] as int?) ?? 0;

    final List<String> participantsUids =
        (acara["participantsUids"] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
            [];

    final bool hasJoined = participantsUids.contains(_currentUid);
    final bool isFull = currentVolunteers >= neededVolunteers;

    void onJoinPressed() {
      if (isCreator) {
        showDeleteConfirmationDialog(
          context,
          acara["title"] as String? ?? 'Acara',
              () => _deleteService.deleteActivity(activityId),
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
            content: Text("Anda sudah bergabung di acara ini."),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        showActivityConfirmDialog(context, acara);
      }
    }

    final bool isButtonDisabled = isFull || hasJoined;

    final String buttonText = isCreator
        ? "Hapus Acara"
        : isFull
        ? "Relawan Penuh"
        : hasJoined
        ? "Sudah Bergabung"
        : "Bantu Acara";

    final Color buttonColor = isCreator
        ? WargaKitaColors.secondary.color
        : isButtonDisabled
        ? Colors.grey
        : const Color(0xFFFE6B35);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            acara["title"] as String? ?? 'Detail Acara',
            textAlign: TextAlign.center,
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
                onPressed: isCreator ? onJoinPressed : (isButtonDisabled ? null : onJoinPressed),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFEDEDED), width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Row(
                children: [
                  const Icon(
                    Icons.person_2_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "$currentVolunteers/$neededVolunteers",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
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

    final String creatorUid = acara["creatorUid"] as String? ?? 'dummy_uid';

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
                    icon: Icons.calendar_today,
                    text: acara["date"] as String? ?? '-',
                    iconColor: WargaKitaColors.secondary.color,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDetailInfo(
                    icon: Icons.access_time,
                    text: acara["time"] as String? ?? 'Belum ada waktu',
                    iconColor: WargaKitaColors.secondary.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _buildDetailInfo(
              icon: Icons.location_on,
              text: acara["location"] as String? ?? 'Lokasi tidak tersedia',
              iconColor: WargaKitaColors.secondary.color,
            ),
            const SizedBox(height: 15),

            _buildCreatorInfo(context, creatorUid),

            Text(
              "Deskripsi Acara",
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              acara["description"] as String? ?? 'Deskripsi tidak tersedia.',
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 2, height: 15, color: Color(0xFFEDEDED)),

            const SizedBox(height: 10),
            Text(
              "Kebutuhan Bantuan",
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              acara["requiredAid"] as String? ??
                  'Kebutuhan bantuan tidak dicantumkan.',
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 2, height: 15, color: Color(0xFFEDEDED)),
            const SizedBox(height: 10),
            Text(
              "Tujuan Acara",
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              acara["goal"] as String? ??
                  'Tujuan acara tidak dicantumkan.',
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                color: WargaKitaColors.black.color,
              ),
            ),

            const SizedBox(height: 20),
            _buildNotesInfoBox(acara["notes"] as String? ?? ''),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        acara["bgColor"] as Color? ?? const Color(0xFF003E6A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.chevron_left, size: 35),
            ),
          ),
        ),
        title: const Text(
          "Detail Acara",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }
}