import 'package:flutter/material.dart';
import '../widget/help_confirmation_dialog.dart';
import '../service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpDetailScreen extends StatefulWidget {
  final Map<String, dynamic> helpItem;

  const HelpDetailScreen({super.key, required this.helpItem});

  @override
  State<HelpDetailScreen> createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends State<HelpDetailScreen> {
  final UserService _userService = UserService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  String _creatorPhoneNumber = '';

  Widget _buildCreatorInfo(BuildContext context, String uid) {
    return FutureBuilder<Map<String, String>>(
      future: _userService.getUserData(uid),
      builder: (context, snapshot) {
        final creatorName = snapshot.data?['username'] ?? 'Memuat...';
        final phoneNumber = snapshot.data?['phoneNumber'] ?? '';

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          if (_creatorPhoneNumber != phoneNumber) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _creatorPhoneNumber = phoneNumber;
              });
            });
          }
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Peminjam",
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
                    style: const TextStyle(
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
    final String creatorUid = widget.helpItem["creatorUid"] as String? ?? 'dummy_uid';
    final bool isCreator = creatorUid == _currentUid;

    void onBantuPressed() {
      if (isCreator) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Anda adalah peminjam. Anda tidak bisa membantu diri sendiri."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (_creatorPhoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nomor telepon peminjam belum tersedia. Mohon tunggu sebentar."),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final Map<String, dynamic> helpItemWithPhone = Map.from(widget.helpItem);
        helpItemWithPhone['phoneNumber'] = _creatorPhoneNumber;
        showHelpConfirmDialog(context, helpItemWithPhone);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Text(
            widget.helpItem["title"] as String? ?? 'Detail Bantuan',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: onBantuPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCreator ? Colors.grey : const Color(0xFFFE6B35),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFEDEDED), width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(isCreator ? "Anda Adalah Peminjam" : "Bantu"),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final String creatorUid = widget.helpItem["creatorUid"] as String? ?? 'dummy_uid';
    final String location = widget.helpItem["location"] as String? ?? 'Lokasi tidak tersedia';

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
            const Text("Titik Bertemu/Lokasi Kegiatan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Color(0xFFFE6B35)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            _buildCreatorInfo(context, creatorUid),

            const Text("Keperluan",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(widget.helpItem["needs"] as String? ?? 'Keperluan tidak dicantumkan.'),
            const SizedBox(height: 20),

            const Text("Deskripsi Barang",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(widget.helpItem["description"] as String? ?? 'Deskripsi barang tidak tersedia.'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003E6A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Detail Bantu",
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