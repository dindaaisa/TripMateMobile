import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';
import 'package:hive/hive.dart';
import 'package:tripmate_mobile/screens/rencana/konfirmasi_pembayaran.dart';

class KonfirmasiRencanaPage extends StatelessWidget {
  final RencanaModel rencana;

  const KonfirmasiRencanaPage({super.key, required this.rencana});

  @override
  Widget build(BuildContext context) {
    final hotelBox = Hive.isBoxOpen('hotelBox')
        ? Hive.box<HotelModel>('hotelBox')
        : null;
    final kamarBox = Hive.isBoxOpen('kamarBox')
        ? Hive.box<KamarModel>('kamarBox')
        : null;

    HotelModel? hotel;
    KamarModel? kamar;

    if (hotelBox != null && rencana.akomodasi != null) {
      try {
        hotel = hotelBox.values.firstWhere((h) => h.nama == rencana.akomodasi);
      } catch (_) {}
    }
    if (hotel != null && kamarBox != null && rencana.kamarNama != null) {
      try {
        kamar = kamarBox.values.firstWhere(
          (k) => k.hotelId == hotel!.key.toString() && k.nama == rencana.kamarNama,
        );
      } catch (_) {}
    }

    final formatter = NumberFormat.decimalPattern('id');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBody: true,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 46, bottom: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      "Konfirmasi Rencana",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // MAIN CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card dengan judul
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          '${rencana.name} (${rencana.sumDate})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AKOMODASI SECTION
                            if (rencana.akomodasi != null && rencana.akomodasi!.isNotEmpty)
                              _buildAkomodasiSection(hotel, kamar, formatter),
                            
                            // TRANSPORTASI SECTION
                            if (rencana.transportasi != null && rencana.transportasi!.isNotEmpty)
                              _buildTransportasiSection(formatter),
                            
                            // MOBIL SECTION
                            if (rencana.mobil != null && rencana.mobil!.isNotEmpty)
                              _buildMobilSection(formatter),
                            
                            // TOTAL SECTION
                            _buildTotalSection(formatter),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
          
          // Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 12),
              top: false,
              child: ModernBarReserve(
                total: (rencana.biayaAkomodasi ?? 0) +
                       (rencana.hargaPesawat ?? 0) +
                       (rencana.hargaMobil ?? 0),
                onKonfirmasi: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KonfirmasiPembayaranPage(rencana: rencana),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAkomodasiSection(HotelModel? hotel, KamarModel? kamar, NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Akomodasi",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        // Hotel Info Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: hotel?.imageBase64 != null && hotel!.imageBase64.isNotEmpty
                      ? Image.memory(
                          base64Decode(hotel!.imageBase64),
                          fit: BoxFit.cover,
                        )
                      : rencana.imageBase64 != null && rencana.imageBase64!.isNotEmpty
                          ? Image.memory(
                              base64Decode(rencana.imageBase64!),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.hotel, color: Colors.white, size: 30),
                            ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Hotel Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel?.nama ?? rencana.akomodasi ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hotel != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[700], size: 14),
                          const SizedBox(width: 2),
                          Text(
                            "${hotel.rating.toStringAsFixed(1)} (${hotel.reviewCount} reviews)",
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(Icons.business, hotel.tipe),
                      _buildInfoRow(Icons.location_on, hotel.lokasi),
                    ],
                    if (kamar != null) ...[
                      _buildInfoRow(Icons.meeting_room, "1 x ${kamar.nama}"),
                      if (kamar.tipeKasur.isNotEmpty)
                        _buildInfoRow(Icons.king_bed, kamar.tipeKasur),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        _buildPriceRow("Total", "1 x Rp ${formatter.format(rencana.biayaAkomodasi ?? 0)}"),
        _buildTotalRow("Total Akomodasi", formatter.format(rencana.biayaAkomodasi ?? 0)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTransportasiSection(NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Transportasi",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        // Flight Info Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flight,
                  color: Color(0xFFDC2626),
                  size: 40,
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rencana.transportasi ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (rencana.asalPesawat != null && rencana.tujuanPesawat != null)
                      Text(
                        "${rencana.asalPesawat} → ${rencana.tujuanPesawat}",
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (rencana.kelasPesawat != null)
                      _buildInfoRow(Icons.airline_seat_recline_normal, "Kelas ${rencana.kelasPesawat}"),
                    if (rencana.waktuPesawat != null)
                      _buildInfoRow(Icons.access_time, 
                        DateFormat('dd MMM yyyy, HH:mm').format(
                          DateTime.tryParse(rencana.waktuPesawat!) ?? DateTime.now()
                        )
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        _buildPriceRow("Total", "${rencana.people} x Rp ${formatter.format((rencana.hargaPesawat ?? 0) ~/ int.parse(rencana.people.isEmpty ? '1' : rencana.people))}"),
        _buildTotalRow("Total Transportasi", formatter.format(rencana.hargaPesawat ?? 0)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMobilSection(NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mobil Pribadi",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        
        // Car Info Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: rencana.imageMobil != null && rencana.imageMobil!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64Decode(rencana.imageMobil!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.directions_car,
                        color: Color(0xFFDC2626),
                        size: 40,
                      ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rencana.mobil ?? "-",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (rencana.tipeMobil != null)
                      _buildInfoRow(Icons.info_outline, rencana.tipeMobil!),
                    if (rencana.jumlahPenumpangMobil != null)
                      _buildInfoRow(Icons.people, "${rencana.jumlahPenumpangMobil}"),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        _buildPriceRow("Total", "1 x Rp ${formatter.format(rencana.hargaMobil ?? 0)}"),
        _buildTotalRow("Total Transportasi", formatter.format(rencana.hargaMobil ?? 0)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTotalSection(NumberFormat formatter) {
    final total = (rencana.biayaAkomodasi ?? 0) +
                  (rencana.hargaPesawat ?? 0) +
                  (rencana.hargaMobil ?? 0);
    
    return Column(
      children: [
        const Divider(thickness: 1),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDC2626).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.receipt_long,
                color: Color(0xFFDC2626),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Total Keseluruhan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                "Rp ${formatter.format(total)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFF666666)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF666666),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.attach_money, size: 16, color: Color(0xFF666666)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet, size: 16, color: Color(0xFFDC2626)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            "Rp $value",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }
}

class ModernBarReserve extends StatelessWidget {
  final int total;
  final VoidCallback? onKonfirmasi;

  const ModernBarReserve({super.key, required this.total, this.onKonfirmasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Text(
                    'Rp ${NumberFormat.decimalPattern('id').format(total)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onKonfirmasi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Konfirmasi Pembayaran',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
