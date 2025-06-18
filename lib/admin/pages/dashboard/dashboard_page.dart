import 'package:flutter/material.dart';
import 'package:tripmate_mobile/admin/pages/dashboard/ubah_landing_page.dart';

class DashboardPage extends StatelessWidget {
  final int totalUsers = 1234;
  final int totalItinerary = 567;

  const DashboardPage({Key? key}) : super(key: key);

  Widget _buildStatCard(String title, int count, double screenWidth) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(screenWidth * 0.045), // responsive
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/ubahLandingPage');
              },
              icon: const Icon(Icons.edit, color: Color(0xFFDC2626)),
              label: const Text(
                'Ubah Landing Page',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.grey.shade300,
                elevation: 6,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Hapus SafeArea, lalu atur padding top manual pada bagian lain jika perlu
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - mentok ke atas, padding top menyesuaikan status bar manual
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: screenWidth * 0.06,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: screenWidth * 0.07),

          // Statistik
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
            child: Row(
              children: [
                _buildStatCard('Total Pengguna Aktif', totalUsers, screenWidth),
                _buildStatCard('Total Itinerary Dibuat', totalItinerary, screenWidth),
              ],
            ),
          ),

          // Tombol navigasi
          _buildNavigationCard(context, screenWidth),
        ],
      ),
    );
  }
}