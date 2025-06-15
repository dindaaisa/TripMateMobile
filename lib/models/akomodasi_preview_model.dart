class AkomodasiPreviewModel {
  /// Nama hotel/villa
  final String namaHotel;

  /// Tipe akomodasi, misal: "Hotel", "Villa", dst.
  final String tipeHotel;

  /// Lokasi utama (misal: "Denpasar, Bali")
  final String lokasi;

  /// Gambar utama hotel dalam base64 (boleh kosong jika tidak ada)
  final String imageBase64;

  /// Rating hotel, contoh: 4.8
  final double rating;

  /// Jumlah review untuk format "4.8 (205 reviews)"
  final int reviewCount;

  /// Nama kamar/tipe kamar yang dipilih
  final String namaKamar;

  /// Size/tipe kasur yang dipilih, misal: "1 double bed, 24 m²"
  final String sizeKasur;

  /// Badge hotel & kamar, contoh: ["Termasuk Sarapan", "Refundable"]
  final List<String> badges;

  /// Estimasi biaya (opsional, untuk ringkasan estimasi)
  final int? estimasiBiaya;

  const AkomodasiPreviewModel({
    required this.namaHotel,
    required this.tipeHotel,
    required this.lokasi,
    required this.imageBase64,
    required this.rating,
    required this.reviewCount,
    required this.namaKamar,
    required this.sizeKasur,
    required this.badges,
    this.estimasiBiaya,
  });
}