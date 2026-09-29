import 'package:flutter/material.dart';
import '../models/course.dart';

class RuangPraktikum extends StatefulWidget {
  const RuangPraktikum({super.key});

  @override
  State<RuangPraktikum> createState() => _RuangPraktikumState();
}

class _RuangPraktikumState extends State<RuangPraktikum> {
  // Mengambil data langsung dari model Course
  final List<Course> _courses = Course.getSampleCourses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isTablet = constraints.maxWidth >= 600;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ruang Praktikum Hari Ini',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildHeaderBadge(Icons.calendar_month,
                          '${_courses.length} sesi', Colors.blue),
                      const SizedBox(width: 12),
                      _buildHeaderBadge(Icons.door_front_door,
                          '1 Ruang Tersedia', Colors.green),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: isTablet
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 280,
                            ),
                            itemCount: _courses.length,
                            itemBuilder: (context, index) =>
                                _buildCard(_courses[index], index),
                          )
                        : ListView.separated(
                            itemCount: _courses.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) =>
                                _buildCard(_courses[index], index),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(IconData icon, String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color.shade700),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Kartu dengan styling dinamis berdasarkan index dan kategori
  Widget _buildCard(Course course, int index) {
    // Variabel untuk menyimpan gaya desain kartu
    String statusLabel;
    String statusMessage;
    Color baseColor;
    Color badgeTextColor = Colors.white;
    IconData statusIcon;

    // Logika penentuan warna & status agar UI menarik (meniru mockup)
    if (course.category == 'Teori') {
      statusLabel = 'Kelas Teori';
      statusMessage = 'Perkuliahan teori di kelas';
      baseColor = const Color(0xFF8B5CF6); // Ungu
      statusIcon = Icons.menu_book_rounded;
    } else if (index == 0) {
      statusLabel = 'Berlangsung';
      statusMessage = 'Sedang digunakan\noleh praktikan';
      baseColor = const Color(0xFF0284C7); // Biru
      statusIcon = Icons.people_alt;
    } else if (index == 1) {
      statusLabel = 'Akan datang';
      statusMessage = 'Sesi akan dimulai\nsebentar lagi';
      baseColor = const Color(0xFFF59E0B); // Oranye
      badgeTextColor = const Color(0xFF78350F);
      statusIcon = Icons.access_time_filled;
    } else if (index == 2) {
      statusLabel = 'Selesai';
      statusMessage = 'Sesi telah selesai';
      baseColor = const Color(0xFF64748B); // Abu-abu
      badgeTextColor = const Color(0xFF334155);
      statusIcon = Icons.check_circle;
    } else {
      statusLabel = 'Tersedia / Siap';
      statusMessage = 'Menunggu jadwal\npraktikum dimulai';
      baseColor = const Color(0xFF10B981); // Hijau
      statusIcon = Icons.laptop_mac;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course.name, // Memanggil nama course
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeTextColor == Colors.white
                      ? baseColor
                      : baseColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time_outlined,
                  size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                course.time, // Memanggil jam course
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                  course.category == 'Teori'
                      ? Icons.business_rounded
                      : Icons.door_front_door_outlined,
                  size: 18,
                  color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                course.room, // Memanggil ruangan course
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: baseColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusMessage,
                    style: TextStyle(
                      color: baseColor.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
