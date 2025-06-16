import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripmate_mobile/models/rencana_model.dart';
import 'package:tripmate_mobile/widgets/home_navigation.dart';

class KonfirmasiPembayaranPage extends StatelessWidget {
  final RencanaModel rencana;
  const KonfirmasiPembayaranPage({super.key, required this.rencana});

  void _onPaymentMethodTap(BuildContext context, String method) async {
    // Validasi yakin pembayaran
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text('Yakin ingin melakukan pembayaran dengan $method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text('Yakin'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Set isPaid menjadi true lalu simpan
      rencana.isPaid = true;
      await rencana.save();

      // Tampilkan pop up pembayaran berhasil
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const _PaymentSuccessDialog(),
        );
        // Setelah pop up, arahkan ke HomeNavigation tab Riwayat & tutup pop up
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop(); // Tutup dialog sukses
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const HomeNavigation(initialTabIndex: 2),
              ),
              (route) => false,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('id');
    final totalBiaya = rencana.biayaAkomodasi ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 14,
              bottom: 24,
            ),
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
                  "Konfirmasi Pembayaran",
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              children: [
                // Card Estimasi Biaya
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 35,
                        offset: Offset(0, -10),
                      ),
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 35,
                        offset: Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 15,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 22),
                      const Text(
                        'Total Biaya Perjalanan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8C8C8C),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp ${formatter.format(totalBiaya)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 112,
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Color(0xFFDC2626),
                                width: 0.5,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          onPressed: () {
                            // Tampilkan sheet/modal detail biaya (implementasi opsional)
                          },
                          child: const Text(
                            'Lihat Rincian',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                const Padding(
                  padding: EdgeInsets.only(left: 2, bottom: 10),
                  child: Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Transfer Bank
                _PaymentMethodCard(
                  title: "Transfer Bank",
                  imagePaths: const [
                    "assets/pics/bca.png",
                    "assets/pics/bni.png",
                    "assets/pics/mandiri.png",
                  ],
                  customHeights: const [
                    24.0, // bca
                    24.0, // bni
                    24.0, // mandiri
                  ],
                  onTap: () => _onPaymentMethodTap(context, "Transfer Bank"),
                ),
                const SizedBox(height: 15),

                // E-Wallet / Dompet Digital
                _PaymentMethodCard(
                  title: "E-Wallet / Dompet Digital",
                  imagePaths: const [
                    "assets/pics/gopay.png",
                    "assets/pics/dana.png",
                    "assets/pics/ovo.png",
                  ],
                  customHeights: const [
                    24.0,
                    24.0,
                    24.0,
                  ],
                  onTap: () => _onPaymentMethodTap(context, "E-Wallet / Dompet Digital"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final List<String> imagePaths;
  final List<double>? customHeights;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.title,
    required this.imagePaths,
    required this.onTap,
    this.customHeights,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Color(0xFF8C8C8C)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (int i = 0; i < imagePaths.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Image.asset(
                        imagePaths[i],
                        height: customHeights != null ? customHeights![i] : 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentSuccessDialog extends StatelessWidget {
  const _PaymentSuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top red bar
            Container(
              height: 40,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  'Pembayaran Berhasil',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.check_circle,
              color: Color(0xFF4CB050),
              size: 60,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}