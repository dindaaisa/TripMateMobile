import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    final int totalPages = 3;

    // Gunakan nilai page yang real-time, bukan _currentPage
    final int currentPage = _pageController.page?.round() ?? _currentPage;

    if (currentPage < totalPages - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          OnBoardingLogo(onNext: _nextPage),
          OnBoardingLanjut(onNext: _nextPage),
          OnBoardingMulai(onNext: _nextPage),
        ],
      ),
    );
  }
}

// Halaman Logo Splash
class OnBoardingLogo extends StatelessWidget {
  final VoidCallback onNext;

  const OnBoardingLogo({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      onNext();
    });

    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'TripMate',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDC2626),
          ),
        ),
      ),
    );
  }
}

// Halaman 1
class OnBoardingLanjut extends StatelessWidget {
  final VoidCallback onNext;

  const OnBoardingLanjut({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/onboarding1.jpg",
              width: 411,
              height: 569,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 569,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _indicator(true),
                    const SizedBox(width: 8),
                    _indicator(false),
                    const SizedBox(width: 8),
                    _indicator(false),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Siap jalan-jalan dan ciptakan pengalaman seru?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Dengan TripMate, atur perjalananmu jadi lebih gampang dan menyenangkan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF71727A),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 15,
            right: 15,
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8F98A8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Lanjut',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDC2626) : const Color(0xFFABB2BE),
        shape: BoxShape.circle,
      ),
    );
  }
}

// Halaman 2
class OnBoardingMulai extends StatelessWidget {
  final VoidCallback onNext;

  const OnBoardingMulai({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/onboarding2.jpg",
              width: 411,
              height: 569,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 569,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _indicator(false),
                    const SizedBox(width: 8),
                    _indicator(true),
                    const SizedBox(width: 8),
                    _indicator(false),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rencanain trip tanpa ribet bareng TripMate!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Cukup beberapa langkah, dan liburan impianmu siap dijalankan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF71727A),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 15,
            right: 15,
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Mulai',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDC2626) : const Color(0xFFABB2BE),
        shape: BoxShape.circle,
      ),
    );
  }
}

