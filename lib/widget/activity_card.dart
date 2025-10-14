import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;
  final List<String> avatars;
  final Color bgColor;

  const ActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.avatars,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double CardWidth = screenWidth * 0.85;

    return Container(
      width: CardWidth,
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          _buildInfoRow(),
          const SizedBox(height: 12),
          _buildParticipantsRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildInfoChip(
            icon: Icons.location_on,
            text: location,
            iconColor: Colors.redAccent,
            isFlexible: true,
          ),
        ),
        const SizedBox(width: 8),
        _buildInfoChip(
          icon: Icons.access_time,
          text: time,
          iconColor: Colors.white,
          isFlexible: false,
        ),
        const SizedBox(width: 8),
        _buildInfoChip(
          icon: Icons.calendar_today,
          text: date,
          iconColor: Colors.white,
          isFlexible: false,
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color iconColor,
    required bool isFlexible,
  }) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: iconColor,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isFlexible ? content : IntrinsicWidth(child: content),
    );
  }

  Widget _buildParticipantsRow() {
    return Row(
      children: [
        for (var avatar in avatars.take(3))
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage(avatar),
            ),
          ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            avatars.length > 3 ? "+${avatars.length - 3} Orang" : "Beberapa Orang",
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white,
        ),
      ],
    );
  }
}