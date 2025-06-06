import 'package:flutter/material.dart';
import 'landing_page_item.dart';

class UbahLandingPage extends StatelessWidget {
  const UbahLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045, vertical: screenWidth * 0.05),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ubah Landing Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // List of LandingPageItem
            Expanded(
              child: ListView(
                children: const [
                  LandingPageItem(pageIndex: 0),
                  LandingPageItem(pageIndex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}