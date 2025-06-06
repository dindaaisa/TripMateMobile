import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'package:tripmate_mobile/models/landing_page_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<ImageProvider> images = [
    const AssetImage('assets/pics/onboarding1.jpg'),
    const AssetImage('assets/pics/onboarding2.jpg'),
  ];

  List<String> titles = [
    'Siap jalan-jalan dan ciptakan pengalaman seru?',
    'Rencanain trip tanpa ribet bareng TripMate!',
  ];

  List<String> subtitles = [
    'Dengan TripMate, atur perjalananmu jadi lebih gampang dan menyenangkan.',
    'Cukup beberapa langkah, dan liburan impianmu siap dijalankan.',
  ];

  @override
  void initState() {
    super.initState();
    loadCustomContent();
    Future.delayed(const Duration(seconds: 2), _nextPage);
  }

  void loadCustomContent() {
    final box = Hive.box<LandingPageModel>('landingPageBox');

    setState(() {
      for (int i = 0; i < 2; i++) {
        final page = box.get(i);
        if (page != null) {
          titles[i] = page.title;
          subtitles[i] = page.description;

          if (page.imageBytes != null) {
            images[i] = MemoryImage(page.imageBytes!);
          }
        }
      }
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return OnBoardingLogo(onNext: _nextPage);
          } else {
            return OnBoardingPage(
              image: images[index - 1],
              title: titles[index - 1],
              subtitle: subtitles[index - 1],
              onNext: _nextPage,
              indicatorIndex: index - 1,
              isVisible: _currentPage == index,
            );
          }
        },
      ),
    );
  }
}

class OnBoardingLogo extends StatelessWidget {
  final VoidCallback onNext;

  const OnBoardingLogo({super.key, required this.onNext});

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

class OnBoardingPage extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final int indicatorIndex;
  final bool isVisible;

  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onNext,
    required this.indicatorIndex,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image(
              image: image,
              width: screenWidth,
              height: screenHeight * 0.52,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: screenHeight * 0.52,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(2, (index) {
                        return Row(
                          children: [
                            _PageIndicator(isActive: index == indicatorIndex),
                            if (index < 1) const SizedBox(width: 8),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF71727A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.08,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
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
                      'Lanjut',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
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