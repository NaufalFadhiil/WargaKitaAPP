import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widget/header_section.dart';
import '../widget/activity_card.dart';
import '../widget/help_card.dart';
import '../style/colors/wargakita_colors.dart';
import '../widget/add_selection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> helpItems = List<Map<String, dynamic>>.from(initialHelpItems);

  void _showSelectionModal() {
    showAddSelectionModal(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: WargaKitaColors.white.color,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderSection(
              userName: "Afif Sasonda",
              date: "Sept 15, 2025",
              profileAsset: "assets/profile1.jpeg",
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
                        "Aktivitas Community",
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Lihat semua",
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Aktivitas Community & Bantuan?",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...communityActivities.map((activity) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail-kegiatan',
                          arguments: activity,
                        );
                      },
                      child: ActivityCard(
                        title: activity['title'],
                        subtitle: activity['subtitle'],
                        date: activity['date'],
                        location: activity['location'],
                        avatars: activity['avatars'],
                        bgColor: activity['bgColor'],
                      ),
                    );
                  }).toList(),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bantu Warga",
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lihat semua",
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: helpItems.length,
              itemBuilder: (context, index) {
                final item = helpItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/help-detail',
                      arguments: item,
                    );
                  },
                  child: HelpCard(
                    title: item['title'],
                    subtitle: item['needs'],
                  ),
                );
              },
            ),
          ],
        ),
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