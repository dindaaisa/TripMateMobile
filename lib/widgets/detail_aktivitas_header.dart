import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/aktivitas_model.dart';

class DetailAktivitasHeader extends StatelessWidget {
  final AktivitasModel aktivitas;
  const DetailAktivitasHeader({super.key, required this.aktivitas});

  @override
  Widget build(BuildContext context) {
    final imageBytes = aktivitas.imageBase64.isNotEmpty ? base64Decode(aktivitas.imageBase64) : null;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Stack(
        children: [
          // Gambar benar-benar full sampai atas
          SizedBox(
            width: double.infinity,
            height: 286,
            child: imageBytes != null
                ? Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.network(
                    "https://placehold.co/413x286",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
          // Gradient overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.56),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // BACK icon, absolute top-left (aman dari notch), TANPA lingkaran
          Positioned(
            left: 12,
            top: MediaQuery.of(context).padding.top + 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: "Kembali",
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          // More icon, TANPA lingkaran
          Positioned(
            right: 12,
            top: MediaQuery.of(context).padding.top + 10,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 26),
              onPressed: () {},
              tooltip: "More",
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          // Aktivitas Name
          Positioned(
            left: 16,
            bottom: 44,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: Text(
                aktivitas.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(offset: Offset(0, 2), blurRadius: 10, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
          // Rating
          Positioned(
            left: 16,
            bottom: 22,
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                const SizedBox(width: 4),
                Text(
                  "${aktivitas.rating.toStringAsFixed(1)} (${aktivitas.jumlahReview} ulasan)",
                  style: const TextStyle(
                    color: Color(0xFF8F98A8),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(offset: Offset(0, 1), blurRadius: 6, color: Colors.black45),
                    ],
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