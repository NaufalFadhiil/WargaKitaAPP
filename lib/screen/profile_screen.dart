import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warga_kita_app/service/user_record_service.dart';
import '../service/user_service.dart';
import '../widget/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final UserActivityService _activityService = UserActivityService();
  String _username = 'Memuat...';
  String _phoneNumber = 'Memuat...';
  String _currentUid = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUid = user.uid;
      final userData = await _userService.getUserData(user.uid);
      setState(() {
        _username = userData['username'] ?? 'Pengguna Tidak Ditemukan';
        _phoneNumber = userData['phoneNumber'] ?? 'Nomor Tidak Tersedia';
      });
    } else {
      setState(() {
        _username = 'Belum Login';
        _phoneNumber = 'Tidak Ada Data';
      });
    }
  }

  Future<Map<String, int>> _loadActivityCounters() async {
    if (_currentUid.isEmpty) return {};

    final results = await Future.wait([
      _activityService.getCreatedActivitiesCount(),
      _activityService.getJoinedActivitiesCount(),
      _activityService.getCreatedHelpRequestsCount(),
      _activityService.getHelpedRequestsCount(),
    ]);

    return {
      'created_activity': results[0],
      'joined_activity': results[1],
      'created_help': results[2],
      'helped_help': results[3],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2E4A6F),
                    Color(0xFF6A5ACD),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Profil Saya",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 55,
                            backgroundImage: AssetImage('assets/images/profile1.jpeg'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E4A6F),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Identitas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF204B69),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Nama",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(_username),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Nomor",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(_phoneNumber),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, int>>(
              future: _loadActivityCounters(),
              builder: (context, snapshot) {
                final data = snapshot.data ??
                    {
                      'created_activity': 0,
                      'joined_activity': 0,
                      'created_help': 0,
                      'helped_help': 0,
                    };

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Riwayat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E4A6F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.7,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _RecordCard(
                            title: "Buat Acara",
                            count: data['created_activity']?.toString() ?? '0',
                            gradientColors: const [Color(0xFF2E4A6F), Color(0xFF6A5ACD)],
                            icon: Icons.group_add_outlined,
                          ),
                          _RecordCard(
                            title: "Bantu Acara",
                            count: data['joined_activity']?.toString() ?? '0',
                            gradientColors: const [Color(0xFFFF7043), Color(0xFFFFA726)],
                            icon: Icons.group_outlined,
                          ),
                          _RecordCard(
                            title: "Buat Pinjaman",
                            count: data['created_help']?.toString() ?? '0',
                            gradientColors: const [Color(0xFF2E4A6F), Color(0xFF6A5ACD)],
                            icon: Icons.waving_hand_outlined,
                          ),
                          _RecordCard(
                            title: "Bantu Pinjaman",
                            count: data['helped_help']?.toString() ?? '0',
                            gradientColors: const [Color(0xFFFF7043), Color(0xFFFFA726)],
                            icon: Icons.handshake_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Developer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E4A6F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "BC25-PG013",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: _DeveloperItem(
                          name: "Riyando Rajagukguk",
                          id: "BC25B055",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _DeveloperItem(
                          name: "Naufal Fadhiil",
                          id: "BC25B059",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: _DeveloperItem(
                          name: "Helmi Shidqi",
                          id: "BC25B062",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _DeveloperItem(
                          name: "Afif Dwi Sasonda",
                          id: "BC25B087",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E4A6F), Color(0xFF6A5ACD)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () => showLogoutConfirmationDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final String title;
  final String count;
  final List<Color> gradientColors;
  final IconData icon;

  const _RecordCard({
    required this.title,
    required this.count,
    required this.gradientColors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 65, maxHeight: 75),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}

class _DeveloperItem extends StatelessWidget {
  final String name;
  final String id;

  const _DeveloperItem({required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(id, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }
}