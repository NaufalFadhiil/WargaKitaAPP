import 'package:flutter/material.dart';

final List<Map<String, dynamic>> communityActivities = [
  {
    "title": "Perayaan 17 Agustus",
    "subtitle": "butuh dukungan warga untuk membantu",
    "date": "Aug 15, 2025",
    "location": "Lapangan Desa Sukamaju",
    "avatars": [
      "assets/profile2.jpeg",
      "assets/profile3.jpeg",
      "assets/profile4.jpeg",
    ],
    "bgColor": const Color(0xFF003366),
  },
  {
    "title": "Kerja Bakti Mingguan",
    "subtitle": "ayo ikut gotong royong bersih-bersih lingkungan",
    "date": "Sept 21, 2025",
    "location": "Gang Melati, RT 03",
    "avatars": [
      "assets/profile3.jpeg",
      "assets/profile4.jpeg",
      "assets/profile2.jpeg",
    ],
    "bgColor": Colors.orange,
  },
  {
    "title": "Donor Darah",
    "subtitle": "bantu PMI dengan donor darah bulan ini",
    "date": "Sept 30, 2025",
    "location": "Balai Warga RW 02",
    "avatars": [
      "assets/profile4.jpeg",
      "assets/profile2.jpeg",
      "assets/profile3.jpeg",
    ],
    "bgColor": Colors.blueGrey,
  },
];

final List<Map<String, dynamic>> initialHelpItems = [
  {
    "title": "Pinjam Sound System 1",
    "subtitle": "Lagi ada acara RT minggu depan, kami butuh sound system untuk hiburan warga.",
    "isChecked": false,
  },
  {
    "title": "Pinjam Sound System 2",
    "subtitle": "Lagi ada acara RT minggu depan, kami butuh sound system untuk hiburan warga.",
    "isChecked": false,
  },
  {
    "title": "Pinjam Sound System 3",
    "subtitle": "Lagi ada acara RT minggu depan, kami butuh sound system untuk hiburan warga.",
    "isChecked": false,
  },
];