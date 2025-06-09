import 'package:flutter/material.dart';

class BannerAkomodasiData {
  final String title;
  final String description;
  final String imageAsset;

  BannerAkomodasiData({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}

class BannerAkomodasi extends StatefulWidget {
  const BannerAkomodasi({super.key});

  @override
  State<BannerAkomodasi> createState() => _BannerAkomodasiState();
}

class _BannerAkomodasiState extends State<BannerAkomodasi> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<BannerAkomodasiData> banners = [
    BannerAkomodasiData(
      title: "Bali",
      description: "180+ pilihan akomodasi favorit\ndengan fasilitas terbaik",
      imageAsset: "assets/pics/purabali.jpg",
    ),
    BannerAkomodasiData(
      title: "Surabaya",
      description: "100+ akomodasi nyaman dan strategis",
      imageAsset: "assets/pics/surabaya.jpg",
    ),
    BannerAkomodasiData(
      title: "Jakarta",
      description: "200+ akomodasi modern untuk perjalananmu",
      imageAsset: "assets/pics/jakarta.png",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bannerHeight = width * 0.48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul di atas banner (boleh kasih padding horizontal)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Akomodasi favorit di destinasi favorit!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Inter',
            ),
          ),
        ),
        // Banner benar-benar full width (tanpa padding/margin dari parent)
        SizedBox(
          width: width,
          height: bannerHeight,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, i) {
                  final data = banners[i];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        data.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                          ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.45),
                              Colors.black.withOpacity(0.05),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: Color(0xFF000000),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: Color(0xFF000000),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              // Indicator
              Positioned(
                bottom: 18,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}