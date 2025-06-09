import 'package:flutter/material.dart';

class CardTipeAkomodasi extends StatelessWidget {
  final List<_TipeAkomodasiData> tipeList = const [
    _TipeAkomodasiData(
      label: "Hotel",
      image: "assets/pics/hotel.jpeg",
    ),
    _TipeAkomodasiData(
      label: "Apartemen",
      image: "assets/pics/apartemen.jpeg",
    ),
    _TipeAkomodasiData(
      label: "Homestay",
      image: "assets/pics/homestay.jpeg",
    ),
    _TipeAkomodasiData(
      label: "Villa",
      image: "assets/pics/villa.jpeg",
    ),
    _TipeAkomodasiData(
      label: "Kapsul",
      image: "assets/pics/kapsul.jpeg",
    ),
    _TipeAkomodasiData(
      label: "Kemah",
      image: "assets/pics/kemah.jpeg",
    ),
  ];

  const CardTipeAkomodasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Hitung lebar grid item agar responsif
    final screenWidth = MediaQuery.of(context).size.width;
    final double padding = 16 * 2;
    final double spacing = 16 * 2;
    final double itemWidth = (screenWidth - padding - spacing) / 3;
    const double itemHeight = 78.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih tipe akomodasi yang cocok untukmu!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tipeList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemBuilder: (context, idx) {
              final tipe = tipeList[idx];
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    Image.asset(
                      tipe.image,
                      fit: BoxFit.cover,
                    ),
                    // Overlay gelap transparan
                    Container(
                      color: Colors.black.withOpacity(0.32),
                    ),
                    // Label
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          tipe.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 4,
                                color: Color(0x40000000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TipeAkomodasiData {
  final String label;
  final String image;
  const _TipeAkomodasiData({
    required this.label,
    required this.image,
  });
}