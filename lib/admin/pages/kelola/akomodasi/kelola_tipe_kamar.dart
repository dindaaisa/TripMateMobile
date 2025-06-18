import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/hotel_model.dart';
import 'package:tripmate_mobile/models/kamar_model.dart';
import 'package:tripmate_mobile/admin/widgets/card_tipe_kamar.dart';

class KelolaTipeKamar extends StatefulWidget {
  final HotelModel hotel;
  const KelolaTipeKamar({Key? key, required this.hotel}) : super(key: key);

  @override
  State<KelolaTipeKamar> createState() => _KelolaTipeKamarState();
}

class _KelolaTipeKamarState extends State<KelolaTipeKamar> {
  final _formKey = GlobalKey<FormState>();
  final Box<KamarModel> kamarBox = Hive.box<KamarModel>('kamarBox');

  final namaController = TextEditingController();
  final ukuranController = TextEditingController();
  final kapasitasController = TextEditingController();
  final kasurController = TextEditingController();
  final hargaController = TextEditingController();

  // Focus nodes untuk mengubah warna border
  final FocusNode namaFocus = FocusNode();
  final FocusNode ukuranFocus = FocusNode();
  final FocusNode kapasitasFocus = FocusNode();
  final FocusNode kasurFocus = FocusNode();
  final FocusNode hargaFocus = FocusNode();

  List<String> fasilitasKamar = [];
  String? imageBase64;
  int? editingIndex;
  List<String> badgesKamar = [];

  final List<String> fasilitasList = [
    "AC",
    "TV",
    "Wi-Fi",
    "Kamar Mandi Dalam",
    "Air Panas",
    "Meja",
    "Mini Bar",
    "Balkon",
  ];

  final List<String> badgeList = [
    "Termasuk Sarapan",
    "Bebas Rokok",
    "Gratis Pembatalan",
  ];

  final Map<String, IconData> fasilitasIconMap = {
    "AC": Icons.ac_unit,
    "TV": Icons.tv,
    "Wi-Fi": Icons.wifi,
    "Kamar Mandi Dalam": Icons.bathtub,
    "Air Panas": Icons.local_fire_department,
    "Meja": Icons.table_bar,
    "Mini Bar": Icons.local_bar,
    "Balkon": Icons.balcony,
  };

  @override
  void dispose() {
    namaController.dispose();
    ukuranController.dispose();
    kapasitasController.dispose();
    kasurController.dispose();
    hargaController.dispose();
    namaFocus.dispose();
    ukuranFocus.dispose();
    kapasitasFocus.dispose();
    kasurFocus.dispose();
    hargaFocus.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan notifikasi sukses
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Fungsi untuk menampilkan notifikasi error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void resetForm() {
    final wasEditing = editingIndex != null;

    namaController.clear();
    ukuranController.clear();
    kapasitasController.clear();
    kasurController.clear();
    hargaController.clear();
    fasilitasKamar.clear();
    badgesKamar.clear();
    imageBase64 = null;
    editingIndex = null;
    setState(() {});

    if (wasEditing) {
      _showSuccessSnackBar('Mode edit dibatalkan. Form telah direset.');
    } else {
      _showSuccessSnackBar('Form berhasil direset dan siap untuk input baru.');
    }
  }

  void pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          imageBase64 = base64Encode(bytes);
        });
        _showSuccessSnackBar('Foto kamar berhasil dipilih dan siap digunakan!');
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih foto. Silakan coba lagi.');
    }
  }

  // Konfirmasi sebelum menyimpan
  Future<bool> _showSaveConfirmation() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFDC2626),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                editingIndex == null ? 'Konfirmasi Tambah Tipe Kamar' : 'Konfirmasi Update Tipe Kamar',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            editingIndex == null
                ? 'Apakah Anda yakin ingin menambahkan tipe kamar "${namaController.text}" ke hotel ${widget.hotel.nama}?'
                : 'Apakah Anda yakin ingin memperbarui data tipe kamar "${namaController.text}"?',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    editingIndex == null ? 'Tambah' : 'Update',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ) ?? false;
  }

  void simpanTipeKamar() async {
    // Validasi form terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Mohon lengkapi semua field yang wajib diisi!');
      return;
    }

    // Validasi fasilitas
    if (fasilitasKamar.isEmpty) {
      _showErrorSnackBar('Pilih minimal 1 fasilitas kamar!');
      return;
    }

    // Validasi badge
    if (badgesKamar.isEmpty) {
      _showErrorSnackBar('Pilih minimal 1 badge kamar!');
      return;
    }

    // Validasi harga
    if (hargaController.text.isEmpty || int.tryParse(hargaController.text) == null || int.parse(hargaController.text) <= 0) {
      _showErrorSnackBar('Masukkan harga yang valid (lebih dari 0)!');
      return;
    }

    // Tampilkan konfirmasi
    final confirmed = await _showSaveConfirmation();
    if (!confirmed) return;

    try {
      final kamar = KamarModel(
        hotelId: widget.hotel.key.toString(),
        nama: namaController.text,
        ukuran: ukuranController.text,
        kapasitas: kapasitasController.text,
        tipeKasur: kasurController.text,
        fasilitas: List.from(fasilitasKamar),
        badges: List.from(badgesKamar),
        harga: int.parse(hargaController.text),
        imageBase64: imageBase64 ?? '',
      );

      if (editingIndex == null) {
        await kamarBox.add(kamar);
        _showSuccessSnackBar('Tipe kamar "${namaController.text}" berhasil ditambahkan ke ${widget.hotel.nama}!');
      } else {
        await kamarBox.putAt(editingIndex!, kamar);
        _showSuccessSnackBar('Tipe kamar "${namaController.text}" berhasil diperbarui!');
      }

      resetForm();
      setState(() {});
    } catch (e) {
      _showErrorSnackBar('Gagal menyimpan tipe kamar. Periksa koneksi dan coba lagi.');
    }
  }

  void editTipeKamar(int index) {
    final kamar = kamarBox.getAt(index);
    if (kamar != null) {
      setState(() {
        editingIndex = index;
        namaController.text = kamar.nama;
        ukuranController.text = kamar.ukuran;
        kapasitasController.text = kamar.kapasitas;
        kasurController.text = kamar.tipeKasur;
        fasilitasKamar = List<String>.from(kamar.fasilitas);
        badgesKamar = List<String>.from(kamar.badges);
        hargaController.text = kamar.harga.toString();
        imageBase64 = kamar.imageBase64.isNotEmpty ? kamar.imageBase64 : null;
      });
      _showSuccessSnackBar('Data "${kamar.nama}" dimuat untuk diedit. Silakan ubah data yang diperlukan.');
    } else {
      _showErrorSnackBar('Data tipe kamar tidak ditemukan!');
    }
  }

  // Konfirmasi sebelum menghapus
  Future<bool> _showDeleteConfirmation(String kamarName) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_outlined, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Konfirmasi Hapus Tipe Kamar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Apakah Anda yakin ingin menghapus tipe kamar "$kamarName"?\n\nTindakan ini tidak dapat dibatalkan.',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ) ?? false;
  }

  void hapusTipeKamar(int index) async {
    final kamar = kamarBox.getAt(index);
    if (kamar == null) {
      _showErrorSnackBar('Data tipe kamar tidak ditemukan!');
      return;
    }

    final confirmed = await _showDeleteConfirmation(kamar.nama);
    if (confirmed) {
      try {
        await kamarBox.deleteAt(index);
        _showSuccessSnackBar('Tipe kamar "${kamar.nama}" berhasil dihapus dari ${widget.hotel.nama}!');
        setState(() {});
      } catch (e) {
        _showErrorSnackBar('Gagal menghapus tipe kamar. Silakan coba lagi.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final kamarList = kamarBox.values
        .where((k) => k.hotelId == widget.hotel.key.toString())
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 48, bottom: 20, left: 28, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Kelola Tipe Kamar",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 38),
                      child: Text(
                        "${widget.hotel.nama} - ${widget.hotel.lokasi}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.045),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    editingIndex == null ? "Masukkan Data Tipe Kamar Baru" : "Edit Data Tipe Kamar",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(
                          controller: namaController,
                          focusNode: namaFocus,
                          label: 'Nama Tipe Kamar',
                          icon: Icons.bed,
                        ),
                        buildTextField(
                          controller: ukuranController,
                          focusNode: ukuranFocus,
                          label: 'Ukuran Kamar (m²)',
                          icon: Icons.square_foot,
                          type: TextInputType.number,
                        ),
                        buildTextField(
                          controller: kapasitasController,
                          focusNode: kapasitasFocus,
                          label: 'Kapasitas Tamu',
                          icon: Icons.people,
                          type: TextInputType.number,
                        ),
                        buildTextField(
                          controller: kasurController,
                          focusNode: kasurFocus,
                          label: 'Tipe Kasur',
                          icon: Icons.king_bed,
                        ),
                        buildTextField(
                          controller: hargaController,
                          focusNode: hargaFocus,
                          label: 'Harga',
                          icon: Icons.attach_money,
                          type: TextInputType.number,
                        ),
                        buildMultiFacilityField(),
                        buildBadgesField(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Unggah Foto Kamar",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: screenWidth * 0.26 + 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: imageBase64 != null
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(
                                          base64Decode(imageBase64!),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Icon(Icons.check, color: Colors.white, size: 20),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_photo_alternate, size: 40, color: Colors.black),
                                        const SizedBox(height: 8),
                                        const Text('Unggah Foto', style: TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (editingIndex != null) ...[
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    resetForm();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[600],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.clear),
                                  label: const Text("Batal Edit"),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: simpanTipeKamar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC2626),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(editingIndex == null ? Icons.add : Icons.update),
                                label: Text(editingIndex == null ? "Tambah Tipe Kamar" : "Update Tipe Kamar"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    'Daftar Tipe Kamar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  kamarList.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.bed_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada tipe kamar yang ditambahkan',
                                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: kamarList.length,
                          itemBuilder: (context, index) {
                            final kamar = kamarList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: CardTipeKamar(
                                kamar: kamar,
                                facilitiesMap: fasilitasIconMap,
                                onEdit: () {
                                  int realIndex = kamarBox.values.toList().indexOf(kamar);
                                  editTipeKamar(realIndex);
                                },
                                onDelete: () {
                                  int realIndex = kamarBox.values.toList().indexOf(kamar);
                                  hapusTipeKamar(realIndex);
                                },
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFFDC2626)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget buildMultiFacilityField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fasilitas Kamar', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fasilitasList.map((fasilitas) {
              final selected = fasilitasKamar.contains(fasilitas);
              final icon = fasilitasIconMap[fasilitas] ?? Icons.check;
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: selected ? Colors.white : Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      fasilitas,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                selected: selected,
                selectedColor: const Color(0xFFDC2626),
                checkmarkColor: Colors.white,
                backgroundColor: Colors.white,
                side: BorderSide(color: selected ? const Color(0xFFDC2626) : Colors.grey),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      fasilitasKamar.add(fasilitas);
                      // Notifikasi ringan untuk feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fasilitas "$fasilitas" ditambahkan'),
                          duration: const Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[600],
                        ),
                      );
                    } else {
                      fasilitasKamar.remove(fasilitas);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fasilitas "$fasilitas" dihapus'),
                          duration: const Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.orange[600],
                        ),
                      );
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (fasilitasKamar.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('Minimal pilih 1 fasilitas.',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            )
        ],
      ),
    );
  }

  Widget buildBadgesField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Badge Kamar', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badgeList.map((badge) {
              final selected = badgesKamar.contains(badge);
              return FilterChip(
                label: Text(
                  badge,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
                selected: selected,
                selectedColor: const Color(0xFFDC2626),
                checkmarkColor: Colors.white,
                backgroundColor: Colors.white,
                side: BorderSide(color: selected ? const Color(0xFFDC2626) : Colors.grey),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      badgesKamar.add(badge);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Badge "$badge" ditambahkan'),
                          duration: const Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[600],
                        ),
                      );
                    } else {
                      badgesKamar.remove(badge);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Badge "$badge" dihapus'),
                          duration: const Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.orange[600],
                        ),
                      );
                    }
                  });
                },
              );
            }).toList(),
          ),
          if (badgesKamar.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('Pilih minimal satu badge.',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            )
        ],
      ),
    );
  }
}