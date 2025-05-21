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

// Halaman Logo Splash - Otomatis lanjut setelah 2 detik
class OnBoardingLogo extends StatefulWidget {
  final VoidCallback onNext;

  const OnBoardingLogo({super.key, required this.onNext});

  @override
  State<OnBoardingLogo> createState() => _OnBoardingLogoState();
}

class _OnBoardingLogoState extends State<OnBoardingLogo> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), widget.onNext); // Auto splash
  }

  @override
  Widget build(BuildContext context) {
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

// Halaman 1 - Lanjut
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
              "assets/pics/onboarding1.jpg",
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
              children: const [
                SizedBox(height: 16),
                Row(
                  children: [
                    _PageIndicator(isActive: true),
                    SizedBox(width: 8),
                    _PageIndicator(isActive: false),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Siap jalan-jalan dan ciptakan pengalaman seru?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Dengan TripMate, atur perjalananmu jadi lebih gampang dan menyenangkan.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF71727A)),
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
}

// Halaman 2 - Mulai
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
              "assets/pics/onboarding2.jpg",
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
              children: const [
                SizedBox(height: 16),
                Row(
                  children: [
                    _PageIndicator(isActive: false),
                    SizedBox(width: 8),
                    _PageIndicator(isActive: true),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Rencanain trip tanpa ribet bareng TripMate!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Cukup beberapa langkah, dan liburan impianmu siap dijalankan.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF71727A)),
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
}

// Indikator halaman (lingkaran kecil)
class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
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
