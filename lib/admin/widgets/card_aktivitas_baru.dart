import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tripmate_mobile/models/aktivitas_model.dart';

class CardAktivitasBaru extends StatelessWidget {
  final AktivitasModel aktivitas;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap; // Parameter untuk handle tap card

  const CardAktivitasBaru({
    Key? key,
    required this.aktivitas,
    required this.onEdit,
    required this.onDelete,
    this.onTap, // Parameter onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Bungkus dengan GestureDetector
      onTap: onTap, // Handle tap card
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            SizedBox(
              height: 160,
              width: double.infinity,
              child: aktivitas.imageBase64.isNotEmpty
                  ? Image.memory(
                      base64Decode(aktivitas.imageBase64),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                      ),
                    ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama dan Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          aktivitas.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            '${aktivitas.formattedRating} (${aktivitas.jumlahReview} reviews)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Tipe
                  Row(
                    children: [
                      Icon(
                        _getTipeIcon(aktivitas.tipe),
                        size: 16,
                        color: Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        aktivitas.tipe,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Lokasi
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${aktivitas.lokasiDetail}, ${aktivitas.lokasi}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Harga dan Tombol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tombol Edit & Hapus di kiri
                      Row(
                        children: [
                          Container(
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Mencegah card tap ketika tombol edit ditekan
                                onEdit();
                              },
                              icon: const Icon(Icons.edit, size: 14),
                              label: const Text('Edit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Mencegah card tap ketika tombol hapus ditekan
                                onDelete();
                              },
                              icon: const Icon(Icons.delete, size: 14),
                              label: const Text('Hapus', style: TextStyle(fontSize: 13,  fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFDC2626),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Harga di kanan
                      Text(
                        aktivitas.formattedHarga,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTipeIcon(String tipe) {
    switch (tipe.toLowerCase()) {
      case 'budaya':
        return Icons.temple_buddhist;
      case 'atraksi':
        return Icons.attractions;
      case 'alam':
        return Icons.landscape;
      default:
        return Icons.place;
    }
  }
}