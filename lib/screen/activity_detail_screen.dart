import 'package:flutter/material.dart';
import '../widget/confirmation_dialog.dart';
import '../service/user_service.dart';


class ActivityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> kegiatan;
  final UserService _userService = UserService();

  ActivityDetailScreen({super.key, required this.kegiatan});

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
              Text(
                "Penyelenggara",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    creatorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
    void onJoinPressed() => showHelpConfirmDialog(  context, kegiatan);

    final Color bgColor = kegiatan["bgColor"] as Color? ?? Color(0xFF003E6A);
    final String neededVolunteers = (kegiatan["neededVolunteers"] as dynamic)?.toString() ?? "0";

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
                onPressed: onJoinPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE6B35),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                        color: Color(0xFFEDEDED), width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
                child: const Text("Join Kegiatan"),
              ),
              Row(
                children: [
                  const Icon(Icons.person_2_outlined,
                      color: Colors.white, size: 30),
                  const SizedBox(width: 6),
                  Text("$neededVolunteers/25",
                      style: TextStyle(
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
                    iconColor: Color(0xFFFE6B35),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDetailInfo(
                    icon: Icons.access_time,
                    text: kegiatan["time"] as String? ?? 'Belum ada waktu',
                    iconColor: Color(0xFFFE6B35),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildDetailInfo(
                    icon: Icons.calendar_today,
                    text: kegiatan["date"] as String? ?? '-',
                    iconColor: Color(0xFFFE6B35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Nama Penyelenggara di atas Deskripsi
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
            const Text("Catatan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(kegiatan["notes"] as String? ?? '-'),
          ],
        ),
      ),
    );
  }
  // End of ActivityDetailScreenContent content


  @override
  Widget build(BuildContext context) {
    final Color bgColor = kegiatan["bgColor"] as Color? ?? Color(0xFF003E6A);

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