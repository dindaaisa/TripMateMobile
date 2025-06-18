import 'package:flutter/material.dart';

class PilihanKuliner extends StatelessWidget {
  final void Function(String kategori)? onTap;
  const PilihanKuliner({super.key, this.onTap});

  // Daftar kategori kuliner sesuai gambar dan urutannya
  static final List<_KulinerKategori> kategoriList = [
    _KulinerKategori("Lokal", "lokal.jpeg"),
    _KulinerKategori("Kuliner Asia", "asia.jpeg"),
    _KulinerKategori("Street Food", "streetfood.jpeg"),
    _KulinerKategori("Cafe & Dessert", "cafe.jpeg"),
    _KulinerKategori("Panorama", "pemandangan.jpeg"),
    _KulinerKategori("BBQ & Grill", "bbq.jpeg"),
    _KulinerKategori("Tradisional", "tradisional.jpeg"),
    _KulinerKategori("Sehat & Halal", "sehat.jpeg"),
    _KulinerKategori("Minuman Hits", "minuman.jpeg"),
    _KulinerKategori("Cepat Saji", "cepatsaji.jpeg"),
  ];

  @override
  Widget build(BuildContext context) {
    // Responsive: 5 kolom di layar lebar, 3-4 di hp kecil
    int crossAxisCount = MediaQuery.of(context).size.width > 500 ? 5 : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            "Pilihan Kuliner",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.black87,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: kategoriList.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.83,
            crossAxisSpacing: 2,
            mainAxisSpacing: 0,
          ),
          itemBuilder: (ctx, i) {
            final kat = kategoriList[i];
            return GestureDetector(
              onTap: () => onTap?.call(kat.nama),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF3F3F3),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/pics/${kat.assetFileName}',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 34, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      kat.nama,
                      style: const TextStyle(fontSize: 12.5),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _KulinerKategori {
  final String nama;
  final String assetFileName;
  const _KulinerKategori(this.nama, this.assetFileName);
}