import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warga_kita_app/style/typography/wargakita_text_styles.dart';
import '../controller/display_activity_controller.dart';
import '../controller/display_help_controler.dart';
import '../data/activity_model.dart';
import '../data/help_model.dart';
import '../style/colors/wargakita_colors.dart';
import '../widget/activity_card.dart';
import '../widget/add_selection.dart';
import '../widget/help_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DisplayActivityController _activityController;
  late final DisplayHelpController _helpController;

  User? _currentUser;
  String _currentDate = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _activityController = DisplayActivityController();
    _helpController = DisplayHelpController();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _currentDate = DateFormat('d MMM, yyyy', 'id_ID').format(DateTime.now());
  }

  void _showSelectionModal() {
    showAddSelectionModal(context);
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  Widget _buildHeaderSection({
    required String userName,
    required String date,
    required String profileAsset,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF003366),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Selamat Datang, $userName",
                style: WargaKitaTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _navigateToProfile,
                child: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile1.jpeg"),
                  radius: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "📅 $date",
            style: WargaKitaTextStyles.bodySmall.copyWith(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              text: "Explore Your\n ",
              style: WargaKitaTextStyles.headlineLarge.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
              children: [
                TextSpan(
                  text: "Community",
                  style: WargaKitaTextStyles.headlineLarge.copyWith(
                    color: WargaKitaColors.secondary.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                TextSpan(
                  text: ", Today!",
                  style: WargaKitaTextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return StreamBuilder<List<ActivityModel>>(
      stream: _activityController.activitiesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: WargaKitaColors.primary.color));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error fetching activities: ${snapshot.error}"),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Belum ada aktivitas komunitas.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        final activities = snapshot.data!;
        const List<Color> bgColors = [
          Color(0xFF003366),
          Color(0xFFFE6B35),
          Colors.blueGrey,
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...activities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;
                final bgColor = bgColors[index % bgColors.length];

                return GestureDetector(
                  onTap: () async {
                    setState(() => _isLoading = true);
                    await Navigator.pushNamed(
                      context,
                      '/detail-acara',
                      arguments: activity.toMap()..['bgColor'] = bgColor,
                    );
                    setState(() => _isLoading = false);
                  },
                  child: ActivityCard(
                    title: activity.title,
                    subtitle: activity.description,
                    date: activity.date,
                    time: activity.time,
                    location: activity.location,
                    neededVolunteers: activity.neededVolunteers,
                    currentVolunteers: activity.currentVolunteers,
                    bgColor: bgColor,
                  ),
                );
              }),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpList() {
    return StreamBuilder<List<HelpData>>(
      stream: _helpController.helpRequestsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: WargaKitaColors.primary.color),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Error fetching help requests: ${snapshot.error}"),
              ));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Belum ada permintaan bantuan.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        final helpItems = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: helpItems.length,
          itemBuilder: (context, index) {
            final item = helpItems[index];
            return GestureDetector(
              onTap: () async {
                setState(() => _isLoading = true);
                await Navigator.pushNamed(
                  context,
                  '/help-detail',
                  arguments: item.toMap(),
                );
                setState(() => _isLoading = false);
              },
              child: HelpCard(title: item.title, subtitle: item.purpose),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = _currentUser?.displayName ?? "Warga Kita";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: WargaKitaColors.white.color,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderSection(
                  userName: userName,
                  date: _currentDate,
                  profileAsset: "assets/images/profile1.jpeg",
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Acara Komunitas",
                            style: WargaKitaTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: WargaKitaColors.black.color,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Bantu Komunitas Mengorganisir Acara",
                        style: WargaKitaTextStyles.bodySmall.copyWith(
                          color: WargaKitaColors.black.color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                _buildActivityList(),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Peminjaman Barang",
                            style: WargaKitaTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: WargaKitaColors.black.color,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                _buildHelpList(),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: WargaKitaColors.white.color,
              child: Center(
                child: CircularProgressIndicator(color: WargaKitaColors.primary.color),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSelectionModal,
        backgroundColor: theme.primaryColor,
        foregroundColor: WargaKitaColors.white.color,
        child: const Icon(Icons.add),
      ),
    );
  }
}