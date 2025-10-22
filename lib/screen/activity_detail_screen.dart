import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warga_kita_app/service/delete_activity_service.dart';
import 'package:warga_kita_app/style/colors/wargakita_colors.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';

import '../provider/user_provider.dart';
import '../service/user_service.dart';
import '../widget/activity_confirmation_dialog.dart';
import '../widget/delete_confirmation_dialog.dart';
import '../data/activity_model.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Map<String, dynamic> acara;

  const ActivityDetailScreen({super.key, required this.acara});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> with RouteAware {
  final UserService _userService = UserService();
  final DeleteActivityService _deleteService = DeleteActivityService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Map<String, dynamic> _acara;
  late Future<Map<String, dynamic>> _activityDataFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _acara = widget.acara;
    _activityDataFuture = _fetchActivityData(_acara["id"] as String? ?? '');
  }

  Future<Map<String, dynamic>> _fetchActivityData(String activityId) async {
    if (activityId.isEmpty) return _acara;

    try {
      final docSnapshot = await _firestore.collection('activities').doc(activityId).get();
      if (docSnapshot.exists) {
        final activityModel = ActivityModel.fromFirestore(docSnapshot);
        final data = activityModel.toMap();
        data['bgColor'] = _acara['bgColor'];
        _acara = data;
        return data;
      }
      return _acara;
    } catch (e) {
      return _acara;
    }
  }

  void _refreshData() {
    setState(() {
      _activityDataFuture = _fetchActivityData(_acara["id"] as String? ?? '');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) is PageRoute) {
      if (ModalRoute.of(context)!.isCurrent) {
      }
    }
  }


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

        if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
          return Center(child: CircularProgressIndicator(color: WargaKitaColors.primary.color));
        }

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

  Widget _buildHeader(BuildContext context, Map<String, dynamic> data) {
    final String creatorUid = data["creatorUid"] as String? ?? 'dummy_uid';
    final String activityId = data["id"] as String? ?? '';
    final bool isCreator = creatorUid == _currentUid;

    final List<String> participantsUids =
        (data["participantsUids"] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ?? [];

    final int neededVolunteers = int.tryParse((data["neededVolunteers"] as dynamic)?.toString() ?? "0") ?? 0;
    final int currentVolunteers = (data["currentVolunteers"] as int?) ?? 0;

    final bool hasJoined = participantsUids.contains(_currentUid);
    final bool isFull = currentVolunteers >= neededVolunteers;


    void onJoinPressed() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (isCreator) {
        showDeleteConfirmationDialog(
          context,
          data["title"] as String? ?? 'Acara',
              () async {
            await _deleteService.deleteActivity(activityId);
            userProvider.refreshUserData();
          },
        );
      } else if (isFull) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Relawan sudah penuh!"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (hasJoined) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Anda sudah bergabung di acara ini."),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() => _isLoading = true);
        await showActivityConfirmDialog(context, data);

        if (!mounted) return;

        userProvider.refreshUserData();
        _refreshData();
        setState(() => _isLoading = false);
      }
    }

    final bool isButtonDisabled = isFull || hasJoined || _isLoading;

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
            data["title"] as String? ?? 'Detail Acara',
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

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    Widget buildDetailInfo({
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

    final String creatorUid = data["creatorUid"] as String? ?? 'dummy_uid';

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
                  child: buildDetailInfo(
                    icon: Icons.calendar_today,
                    text: data["date"] as String? ?? '-',
                    iconColor: WargaKitaColors.secondary.color,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: buildDetailInfo(
                    icon: Icons.access_time,
                    text: data["time"] as String? ?? 'Belum ada waktu',
                    iconColor: WargaKitaColors.secondary.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            buildDetailInfo(
              icon: Icons.location_on,
              text: data["location"] as String? ?? 'Lokasi tidak tersedia',
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
              data["description"] as String? ?? 'Deskripsi tidak tersedia.',
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
              data["requiredAid"] as String? ??
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
              data["goal"] as String? ??
                  'Tujuan acara tidak dicantumkan.',
              style: WargaKitaTextStyles.bodyMedium.copyWith(
                color: WargaKitaColors.black.color,
              ),
            ),

            const SizedBox(height: 20),
            _buildNotesInfoBox(data["notes"] as String? ?? ''),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _acara["bgColor"] as Color? ?? const Color(0xFF003E6A);

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
        child: FutureBuilder<Map<String, dynamic>>(
          future: _activityDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: WargaKitaColors.white.color,
                child: Center(child: CircularProgressIndicator(color: WargaKitaColors.primary.color)),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Gagal memuat detail acara.", style: TextStyle(color: WargaKitaColors.primary.color)));
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