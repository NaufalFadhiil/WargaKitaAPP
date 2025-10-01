import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> checkedList = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                    children: const [
                      Text(
                        "Hello, Afif Sasonda",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/profile1.jpeg"),
                        radius: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "📅 Sept 15, 2025",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  const Text.rich(
                    TextSpan(
                      text: "Explore Your\n ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      children: [
                        TextSpan(
                          text: "Community",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: ", Today!",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Aktivitas Community",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Lihat semua",
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Aktivitas Community & Bantuan?",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBanner(
                    context,
                    title: "Perayaan 17 Agustus",
                    subtitle: "butuh dukungan warga untuk membantu",
                    date: "Aug 15, 2025",
                    location: "Lapangan Desa Sukamaju",
                    avatars: const [
                      "assets/profile2.jpeg",
                      "assets/profile3.jpeg",
                      "assets/profile4.jpeg",
                    ],
                    bgColor: const Color(0xFF003366),
                  ),
                  _buildBanner(
                    context,
                    title: "Kerja Bakti Mingguan",
                    subtitle: "ayo ikut gotong royong bersih-bersih lingkungan",
                    date: "Sept 21, 2025",
                    location: "Gang Melati, RT 03",
                    avatars: const [
                      "assets/profile3.jpeg",
                      "assets/profile4.jpeg",
                      "assets/profile2.jpeg",
                    ],
                    bgColor: Colors.orange,
                  ),
                  _buildBanner(
                    context,
                    title: "Donor Darah",
                    subtitle: "bantu PMI dengan donor darah bulan ini",
                    date: "Sept 30, 2025",
                    location: "Balai Warga RW 02",
                    avatars: const [
                      "assets/profile4.jpeg",
                      "assets/profile2.jpeg",
                      "assets/profile3.jpeg",
                    ],
                    bgColor: Colors.blueGrey,
                  ),
                  const SizedBox(width: 16), 
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Bantu Warga",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lihat semua",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checkedList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkedList[index],
                  onChanged: (value) {
                    setState(() {
                      checkedList[index] = value ?? false;
                    });
                  },
                  title: Text(
                    "Pinjam Sound System ${index + 1}",
                    style: TextStyle(
                      decoration: checkedList[index]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: const Text(
                    "Lagi ada acara RT minggu depan, kami butuh sound system untuk hiburan warga.",
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  static Widget _buildBanner(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String date,
    required String location,
    required List<String> avatars,
    required Color bgColor,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double bannerWidth = screenWidth * 0.81;

    return Container(
      width: bannerWidth,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          location,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var avatar in avatars)
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
                  "+2 Orang",
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
          ),
        ],
      ),
    );
  }
}
