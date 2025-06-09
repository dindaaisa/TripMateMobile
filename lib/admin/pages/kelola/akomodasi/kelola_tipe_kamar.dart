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
    "Superior",
    "Deluxe",
    "Suite",
    "Populer",
    "Promo",
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
    super.dispose();
  }

  void resetForm() {
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
  }

  void pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        imageBase64 = base64Encode(bytes);
      });
    }
  }

  void simpanTipeKamar() {
    if (_formKey.currentState!.validate() &&
        fasilitasKamar.isNotEmpty &&
        badgesKamar.isNotEmpty &&
        hargaController.text.isNotEmpty) {
      final kamar = KamarModel(
        hotelId: widget.hotel.key.toString(),
        nama: namaController.text,
        ukuran: ukuranController.text,
        kapasitas: kapasitasController.text,
        tipeKasur: kasurController.text,
        fasilitas: List.from(fasilitasKamar),
        badges: List.from(badgesKamar),
        harga: int.tryParse(hargaController.text) ?? 0,
        imageBase64: imageBase64 ?? '',
      );

      if (editingIndex == null) {
        kamarBox.add(kamar);
      } else {
        kamarBox.putAt(editingIndex!, kamar);
      }
      resetForm();
      setState(() {});
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
        imageBase64 = kamar.imageBase64;
      });
    }
  }

  void hapusTipeKamar(int index) {
    kamarBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final kamarList = kamarBox.values
        .where((k) => k.hotelId == widget.hotel.key.toString())
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F5),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER RAPIH SESUAI GAMBAR (Image 4) - tanpa lingkaran, subjudul rata kiri dengan judul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 48, bottom: 20, left: 28, right: 20
              ),
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
                      padding: const EdgeInsets.only(left: 38), // left: ikon + sizedbox
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
                  const Text(
                    "Form Tipe Kamar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(
                          controller: namaController,
                          label: 'Nama Tipe Kamar',
                          icon: Icons.bed,
                        ),
                        buildTextField(
                          controller: ukuranController,
                          label: 'Ukuran Kamar (m²)',
                          icon: Icons.square_foot,
                          type: TextInputType.number,
                        ),
                        buildTextField(
                          controller: kapasitasController,
                          label: 'Kapasitas Tamu',
                          icon: Icons.people,
                          type: TextInputType.number,
                        ),
                        buildTextField(
                          controller: kasurController,
                          label: 'Tipe Kasur',
                          icon: Icons.king_bed,
                        ),
                        buildTextField(
                          controller: hargaController,
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
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                      base64Decode(imageBase64!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(child: Text('Unggah Foto')),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: simpanTipeKamar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.save),
                            label: const Text("Simpan"),
                          ),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: kamarList.length,
                    itemBuilder: (context, index) {
                      final kamar = kamarList[index];
                      return CardTipeKamar(
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
    required String label,
    required IconData icon,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
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
              return FilterChip(
                label: Text(fasilitas),
                selected: selected,
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      fasilitasKamar.add(fasilitas);
                    } else {
                      fasilitasKamar.remove(fasilitas);
                    }
                  });
                },
                selectedColor: Colors.red[400],
                checkmarkColor: Colors.white,
                backgroundColor: const Color(0xFFFDF4F5),
                labelStyle: TextStyle(
                  color: selected ? Colors.red[900] : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selected ? Colors.red : Colors.grey.shade400,
                  ),
                ),
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
            spacing: 10,
            runSpacing: 6,
            children: badgeList.map((badge) {
              final selected = badgesKamar.contains(badge);
              return FilterChip(
                label: Text(badge),
                selected: selected,
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      badgesKamar.add(badge);
                    } else {
                      badgesKamar.remove(badge);
                    }
                  });
                },
                selectedColor: Colors.red[400],
                checkmarkColor: Colors.white,
                backgroundColor: const Color(0xFFFDF4F5),
                labelStyle: TextStyle(
                  color: selected ? Colors.red[900] : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selected ? Colors.red : Colors.grey.shade400,
                  ),
                ),
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