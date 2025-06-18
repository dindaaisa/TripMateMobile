import 'package:flutter/material.dart';

class KategoriAktivitas extends StatelessWidget {
  final void Function(String kategori)? onTap;

  const KategoriAktivitas({super.key, this.onTap});

  static final List<_Kategori> kategoriList = [
    _Kategori("Atraksi", "assets/pics/atraksi.png"),
    _Kategori("Hiburan", "assets/pics/hiburan.png"),
    _Kategori("Alam", "assets/pics/alam.png"),
    _Kategori("Belanja", "assets/pics/belanja.png"),
    _Kategori("Budaya", "assets/pics/budaya.png"),
    _Kategori("Relaksasi", "assets/pics/relaksasi.png"),
    _Kategori("Petualangan", "assets/pics/petualangan.png"),
    _Kategori("Aktivitas Air", "assets/pics/aktivitasair.png"),
    _Kategori("Seni", "assets/pics/seni.png"),
    _Kategori("Edukasi", "assets/pics/edukasi.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Pilih Kategori Aktivitas!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: kategoriList.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.85,
            crossAxisSpacing: 0,
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
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF3F3F3),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      kat.assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 34, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 5),
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

class _Kategori {
  final String nama;
  final String assetPath;
  const _Kategori(this.nama, this.assetPath);
}