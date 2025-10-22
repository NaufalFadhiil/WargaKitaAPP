import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warga_kita_app/service/delete_help_service.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
import '../widget/help_confirmation_dialog.dart';
import '../provider/user_provider.dart';
import '../service/user_service.dart';
import '../widget/delete_confirmation_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/help_model.dart';

class HelpDetailScreen extends StatefulWidget {
  final Map<String, dynamic> helpItem;

  const HelpDetailScreen({super.key, required this.helpItem});

  @override
  State<HelpDetailScreen> createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends State<HelpDetailScreen> {
  final UserService _userService = UserService();
  final DeleteHelpService _deleteService = DeleteHelpService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<Map<String, dynamic>> _helpDataFuture;
  String _creatorPhoneNumber = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _helpDataFuture = _fetchHelpData(widget.helpItem["id"] as String? ?? '');
  }

  Future<Map<String, dynamic>> _fetchHelpData(String helpId) async {
    if (helpId.isEmpty) return widget.helpItem;

    try {
      final docSnapshot = await _firestore.collection('help_requests').doc(helpId).get();
      if (docSnapshot.exists) {
        final helpModel = HelpData.fromFirestore(docSnapshot);
        return helpModel.toMap();
      }
      return widget.helpItem;
    } catch (e) {
      return widget.helpItem;
    }
  }

  void _refreshData() {
    setState(() {
      _helpDataFuture = _fetchHelpData(widget.helpItem["id"] as String? ?? '');
    });
  }

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

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: WargaKitaColors.primary.color));
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

  Widget _buildHeader(BuildContext context, Map<String, dynamic> data) {
    final String creatorUid = data["creatorUid"] as String? ?? 'dummy_uid';
    final String helpId = data["id"] as String? ?? '';
    final bool isCreator = creatorUid == _currentUid;

    final List<String> helpersUids = (data["helpersUids"] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];

    final bool hasHelped = helpersUids.contains(_currentUid);

    void onBantuPressed() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (isCreator) {
        showDeleteConfirmationDialog(
          context,
          data["title"] as String? ?? 'Permintaan Peminjaman',
              () async {
            await _deleteService.deleteHelpRequest(helpId);
            userProvider.refreshUserData();
          },
        );
      } else if (hasHelped) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Anda sudah menawarkan bantuan."),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (_creatorPhoneNumber.isEmpty) {
        if (!mounted) return;
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
        setState(() => _isLoading = true);
        final Map<String, dynamic> helpItemWithPhone = Map.from(data);
        helpItemWithPhone['phoneNumber'] = _creatorPhoneNumber;
        final bool confirmed = await showHelpConfirmDialog(context, helpItemWithPhone);

        if (!mounted) return;

        if (confirmed == true) {
          userProvider.refreshUserData();
          _refreshData();
        }

        setState(() => _isLoading = false);
      }
    }

    String buttonText = "Bantu Peminjaman";
    Color buttonColor = const Color(0xFFFE6B35);
    bool isDisabled = _isLoading || (!isCreator && hasHelped);

    if (isCreator) {
      buttonText = "Hapus Peminjaman";
      buttonColor = WargaKitaColors.secondary.color;
      isDisabled = false;
    } else if (hasHelped) {
      buttonText = "Sudah Menawarkan Bantuan";
      buttonColor = Colors.grey;
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
              data["title"] as String? ?? 'Detail Peminjaman',
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
          child: SizedBox(
            child: ElevatedButton(
              onPressed: isDisabled && !isCreator ? null : onBantuPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFEDEDED), width: 2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final String creatorUid = data["creatorUid"] as String? ?? 'dummy_uid';
    final String location = data["location"] as String? ?? 'Lokasi tidak tersedia';

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
              "Titik Bertemu",
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
              data["needs"] as String? ??
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
              data["description"] as String? ??
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
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
        title: Text(
          "Detail Peminjaman",
          style: WargaKitaTextStyles.headlineLarge.copyWith(
            fontSize: 20,
            color: WargaKitaColors.white.color,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _helpDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: WargaKitaColors.white.color,
                child: Center(child: CircularProgressIndicator(color: WargaKitaColors.primary.color)),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Gagal memuat detail peminjaman.", style: TextStyle(color: WargaKitaColors.primary.color)));
            }

            final data = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, data),
                Expanded(child: _buildContent(context, data)),
              ],
            );
          },
        ),
      ),
    );
  }
}