import 'package:flutter/material.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
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

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          if (_creatorPhoneNumber != phoneNumber) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _creatorPhoneNumber = phoneNumber;
              });
            });
          }
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Peminjam:",
                style: WargaKitaTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: WargaKitaColors.secondary.color,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.person,
                color: WargaKitaColors.primary.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              // Expanded agar nama panjang tidak memaksa overflow
              Expanded(
                child: Text(
                  creatorName,
                  style: WargaKitaTextStyles.bodyMedium.copyWith(
                    color: WargaKitaColors.black.color,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String creatorUid =
        widget.helpItem["creatorUid"] as String? ?? 'dummy_uid';
    final bool isCreator = creatorUid == _currentUid;

    void onBantuPressed() {
      if (isCreator) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Anda adalah peminjam. Anda tidak bisa membantu diri sendiri.",
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (_creatorPhoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Nomor telepon peminjam belum tersedia. Mohon tunggu sebentar.",
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final Map<String, dynamic> helpItemWithPhone = Map.from(
          widget.helpItem,
        );
        helpItemWithPhone['phoneNumber'] = _creatorPhoneNumber;
        showHelpConfirmDialog(context, helpItemWithPhone);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Center(
            child: Text(
              widget.helpItem["title"] as String? ?? 'Detail Bantuan',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: onBantuPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCreator
                  ? Colors.grey
                  : const Color(0xFFFE6B35),
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
    final String creatorUid =
        widget.helpItem["creatorUid"] as String? ?? 'dummy_uid';
    final String location =
        widget.helpItem["location"] as String? ?? 'Lokasi tidak tersedia';

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
            Text(
              "Titik Bertemu/Lokasi Kegiatan",
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_on, color: WargaKitaColors.secondary.color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    style: WargaKitaTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: WargaKitaColors.black.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            _buildCreatorInfo(context, creatorUid),

            const SizedBox(height: 12),
            const Divider(thickness: 2, height: 15, color: Color(0xFFEDEDED)),

            Text(
              "Keperluan",
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.helpItem["needs"] as String? ??
                  'Keperluan tidak dicantumkan.',
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                color: WargaKitaColors.black.color,
              ),
            ),

            const SizedBox(height: 8),
            const Divider(thickness: 2, height: 15, color: Color(0xFFEDEDED)),

            Text(
              "Deskripsi Barang",
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: WargaKitaColors.black.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.helpItem["description"] as String? ??
                  'Deskripsi barang tidak tersedia.',
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                color: WargaKitaColors.black.color,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
        title: Text(
          "Detail Bantu",
          style: WargaKitaTextStyles.headlineLarge.copyWith(
            fontSize: 20,
            color: WargaKitaColors.white.color,
          ),
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
